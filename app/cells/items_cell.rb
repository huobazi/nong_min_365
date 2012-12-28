# -*- encoding : utf-8 -*-
class ItemsCell < Cell::Rails

  def homepage_latest_items(args = {})
    categories  = args[:categories]
    category_id = args[:category_id]

    @category = categories.find{|x| x.id == category_id}
    @items = Item.latest.where(:category_id => category_id)

    render
  end

end
