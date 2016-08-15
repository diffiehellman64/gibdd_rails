class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  before_filter :set_paper_trail_whodunnit

 # rescue_from CanCan::AccessDenied do |exception|
 #   render status: :forbidden, text: "Forbidden </br> #{exception.message}"
 # end

  rescue_from CanCan::AccessDenied do |exception|
    if request.headers['X-PJAX'] # pjax
      render_403 exception.message
    elsif request.xhr? # ajax
      render js: "showAppMessage ('danger^У Вас не хватает полномочий для этого действия');", status: :forbidden
    else 
      redirect_to main_app.root_path, flash: { danger: "<strong>#{t('errors.forbidden')}:</strong> #{exception.message}" }
    end
  end

  rescue_from OCI8::OCIError do |exception|
    render js: "showAppMessage ('danger^Проблемы соединения с базой данных Oracle: #{exception.message}');"
  end

  def pjax_redirect_to(url, container = '[pjax-container]', message = '')
    render js: "$.pjax({url: '#{url}', container: '#{container}'}); showAppMessage ('#{message}');"
  end
  
  def show_js_message(message)
    render js: "showAppMessage ('#{message}');"
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def ott_conn
    pass = IO.read('config/pass_ott')
    return  OCI8.new('SYS', pass, '//10.66.14.213:1521/GIBDDRK', :SYSDBA)
  end

  def aius_conn
    pass = IO.read('config/pass_aius')
    return OCI8.new('MCHS', pass, '//10.66.14.11:1521/AIUP')
  end

  def oci_disconn(conn)
    conn.logoff
  end

end
