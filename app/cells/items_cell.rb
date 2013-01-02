# -*- encoding : utf-8 -*-
class ItemsCell < Cell::Rails
   helper ActsAsTaggableOn::TagsHelper
   
  def homepage_latest_items(args={})
    categories  = args[:categories]
    category_id = args[:category_id]
    row_count   = args[:row_count]

    @category = categories.find{|x| x.id == category_id}
    @items = Item.latest.where(:category_id => category_id).limit(row_count)

    render
  end

  def tag_cloud(args={})
    @tags = Item.tag_counts_on(:tags)
    render
  end

end
