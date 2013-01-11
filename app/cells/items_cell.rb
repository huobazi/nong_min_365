# -*- encoding : utf-8 -*-
class ItemsCell < Cell::Rails
  helper ActsAsTaggableOn::TagsHelper

  cache :homepage_categories_navbar, :expires_in => 60.minutes
  cache :homepage_latest_items_wrapper, :expires_in => 10.minutes
  cache :homepage_latest_items, :expires_in => 10.minutes do |cell, opts|
    "homepage_latest_items/#{opts[:category_id]}/#{opts[:row_count]}"
  end
  cache :tag_cloud, :expires_in => 20.minutes

  def homepage_categories_navbar(args={})
    @categories = args[:categories] || Category.all
    render
  end

  def homepage_latest_items_wrapper(args={})
    @categories = args[:categories] || Category.all
    render
  end

  def homepage_latest_items(args={})
    category_id = args[:category_id]
    row_count   = args[:row_count]
    categories  = args[:categories] || Category.all

    @category = categories.find{|x| x.id == category_id}
    @items = Item.latest.where(:category_id => category_id).limit(row_count)
    render
  end

  def tag_cloud(args={})
    @tags = Item.tag_counts_on(:tags)
    render
  end

end
