# -*- encoding : utf-8 -*-

require 'item'
class ItemsCell < Cell::Rails
  helper ActsAsTaggableOn::TagsHelper

  cache :homepage_categories_navbar, :expires_in => 60.minutes
  cache :homepage_latest_items_wrapper, :expires_in => 10.minutes
  cache :homepage_latest_items, :expires_in => 10.minutes do |cell, opts|
    "homepage_latest_items/#{opts[:category_id]}/#{opts[:row_count]}"
  end
  cache :tag_cloud, :expires_in => 20.minutes

  def homepage_categories_navbar(args={})
    @categories = args[:categories] || Category.roots
    render
  end

  def homepage_latest_items_wrapper(args={})
    @categories = args[:categories] || Category.roots
    render
  end

  def homepage_latest_items(args={})
    category_id = args[:category_id]
    row_count   = args[:row_count]
    categories  = args[:categories] || Category.roots
    @category = categories.find{|x| x.id == category_id}
    @items = Rails.cache.fetch("global/homepage/latest/items_#{category_id}_#{row_count}",expires_in: 20.minutes) do
      @category.items.latest.limit(row_count).all
    end
    render
  end

  def tag_cloud(args={})
    @tags = Rails.cache.fetch("Items.tag_counts_on:tags", expires_in: 30.minutes) do
      Item.tag_counts_on(:tags).limit(300).all
    end
    render
  end

end
