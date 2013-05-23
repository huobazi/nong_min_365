# -*- encoding : utf-8 -*-
class PicturesController < ApplicationController
  load_and_authorize_resource

  before_filter :find_item

  def index
    @pictures = @item.pictures
    @picture = Picture.new

    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @pictures }
    end
  end

  def create
    @picture = @item.pictures.build(params[:picture])

    respond_to do |wants|
      if @picture.save
        flash[:notice] = '图片上传成功'
        wants.html { redirect_to(@picture) }
        wants.xml  { render :xml => @picture, :status => :created, :location => @picture }
      else
        #@pictures = Picture.where({:imageable_id => @item.id, :imageable_type => 'Item'})
        @pictures = @pictures.where('id > 0')
        wants.html { render :action => "index" }
        wants.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |wants|
      wants.html { redirect_to(pictures_url) }
      wants.xml  { head :ok }
    end
  end

  private
  def find_item
    @item = Item.find params[:item_id]
  end

end
