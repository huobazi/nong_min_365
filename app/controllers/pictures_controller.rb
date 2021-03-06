# -*- encoding : utf-8 -*-
class PicturesController < ApplicationController
  load_and_authorize_resource

  before_filter :find_item, :set_breadcrumb

  def index
    @pictures = @item.pictures

    respond_to do |wants|
      wants.html # index.html.erb
    end
  end

  def new
    @pictures = @item.pictures
    #@picture = @item.pictures.build
    @picture = Picture.new

    respond_to do |wants|
      wants.html # new.html.erb
    end
  end

  def create
    if @item.pictures.size >= 6
      respond_to do |wants|
        flash[:error] = '每条信息最多允许上传六张图,如果您想更新某图片，可将其先删除,然后再上传新图片。'
        wants.html { redirect_to new_item_picture_path(@item) }
      end
      return
    end

    @picture = @item.pictures.build(params[:picture])

    if @picture.save
      flash[:notice] = '图片上传成功'
      redirect_to new_item_picture_path(@item)
    else
      @pictures = Picture.where({:imageable_id => @item.id, :imageable_type => 'Item'})
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    flash[:notice] = '删除图片成功'
    redirect_to new_item_picture_path(@item)

  end

  def set_to_priamary
    @picture = Picture.find(params[:id])
    @picture.set_to_priamary

    flash[:notice] = '设置主图片成功'
    redirect_to new_item_picture_path(@item)

  end

  private
  def find_item
    @item = Item.find params[:item_id]
  end

  def set_breadcrumb
    drop_breadcrumb('产品', items_path)
    drop_breadcrumb(@item.category.name, condition_list_items_path(:category => @item.category_id, :xtype => nil, :area => nil) )
    drop_breadcrumb(@item.xtype == 1 ? '供应':'求购', condition_list_items_path(:category => @item.category_id, :xtype => @item.xtype, :area => nil) )
    drop_breadcrumb(@item.province_name, condition_list_items_path(:area => @item.province_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.city_name, condition_list_items_path(:area => @item.city_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.county_name, condition_list_items_path(:area => @item.county_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.town_name, condition_list_items_path(:area => @item.town_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.village_name, condition_list_items_path(:area => @item.village_code, :category => @item.category_id, :xtype => @item.xtype ) )
    drop_breadcrumb(@item.title, item_path(@item) )


  end

end
