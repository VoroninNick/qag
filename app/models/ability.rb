class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard              # grant access to the dashboard
      can :manage, :all
    end
  end
end
