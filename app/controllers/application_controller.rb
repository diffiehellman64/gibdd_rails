class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

 # rescue_from CanCan::AccessDenied do |exception|
 #   render status: :forbidden, text: "Forbidden </br> #{exception.message}"
 # end

  rescue_from CanCan::AccessDenied do |exception|
    if request.headers['X-PJAX'] # pjax
      render_403 exception.message
    elsif request.xhr? # ajax
      render status: :forbidden, text: 'Forbidden'
    else 
      redirect_to main_app.root_path, flash: { danger: "<strong>#{t('errors.forbidden')}:</strong> #{exception.message}" }
    end
  end

  def pjax_redirect_to(url, container = '[pjax-container]')
    render js: "$.pjax({url: '#{url}', container: '#{container}'});"
  end


  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
