# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      # not logged in
      cannot :manage, :all
      basic_read_only
    elsif user.has_role?(:admin) or user.has_role?(:founder)
      # admin or founder
      can :manage, :all
    elsif user.has_role?(:member)
      # Item 
      can :create, Item 
      can :update, Item do |item|
        (item.user_id == user.id)
      end
      
      #can :destroy, Item do ||
        #(item.user_id == user.id)
      #end

      basic_read_only
    else
      # banned or unknown situation
      cannot :manage, :all
      basic_read_only
    end
  end

  protected
  def basic_read_only
    can :read,Item
    can :tags, Item 
    can :show_hits,Item
  end
end
