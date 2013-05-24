# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, :to => :modify

    if user.blank?
      # not logged in
      cannot :manage, :all
    elsif user.has_role?(:admin) or user.has_role?(:founder)
      # admin or founder
      can :manage, :all
      anonymous_basic_access
    elsif user.has_role?(:member)
      # Item
      can :create, Item
      can [:update, :destroy], Item do |item|
        (item.user_id == user.id)
      end

      can [:create, :destroy], Picture, :imageable => { :user_id => user.id }

    else
      # banned or unknown situation
      cannot :manage, :all
    end


    anonymous_basic_access
  end

  protected
  def anonymous_basic_access
    can :read, Item
    can :read, Picture
    can :tags, Item
    can :show_hits, Item
  end
end
