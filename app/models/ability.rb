class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :index, :show, :new, :edit, :create, :update, :destroy, :validate, :all, :cafap, :import, :emergency_data, to: :all_privileges
    alias_action :new, :edit, :create, :update, to: :create_edit
    alias_action :edit, :update, to: :edit_update
    alias_action :index, :show, to: :read
    
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :all_privileges, OperativeRecord
      
    elsif user.has_role? :ugibdd_duty
      can :create, OperativeRecord
      can :index, OperativeRecord
      can :validate, OperativeRecord
      can :all, OperativeRecord
      can :edit_update, OperativeRecord

    elsif user.has_role? :operative_duty
      can :create, OperativeRecord
      can :index, OperativeRecord
      can :validate, OperativeRecord
      can :all, OperativeRecord

      can :edit_update, OperativeRecord do |rec|
        rec.try(:district_id) == user.district_id
      end
    # Guest
    else
#      can :all, OperativeRecord
    end

  end
end
