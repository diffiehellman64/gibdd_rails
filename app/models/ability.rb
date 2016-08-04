class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :index, :show, :new, :edit, :create, :update, :destroy, :validate, :all, to: :all_privileges
    alias_action :new, :edit, :create, :update, to: :create_edit
    alias_action :edit, :update, to: :edit_update
    alias_action :index, :show, to: :read
    
    user ||= User.new # guest user (not logged in)


    if user.has_role? :admin
      can :all_privileges, OperativeRecord
      
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
      #can :read, OperativeRecord
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
