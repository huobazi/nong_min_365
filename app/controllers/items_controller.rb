# -*- encoding : utf-8 -*-
class ItemsController < ApplicationController
  respond_to :js, :only => [:create, :update, :destroy]

  # GET /items
  def index
    @items = Item.all
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
    @provinces = ChineseRegion.provinces
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    @provinces = ChineseRegion.provinces
    children_level, @cities = ChineseRegion.children(@item.province_code)
    children_level, @counties = ChineseRegion.children(@item.city_code)
    children_level, @towns = ChineseRegion.children(@item.county_code)
    children_level, @villages = ChineseRegion.children(@item.town_code)
  end

  # POST /items
  def create
    @item = Item.new(params[:item])
    @item.user_id = 0
    @item.ip = request.remote_ip

    if signed_in?
      @item.user_id = current_user.id
    end

    respond_to do |format|
      if @item.save
        format.js { render :layout => false }
        format.mobile{ redirect_to root_url, :notice => "注册成功！" }
      else
        format.mobile{ render 'new' }
        format.js { render :layout => false }
      end
    end

  end

  # PUT /items/1
  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.js{render :layout => false }
      else
        format.js{render :layout => false }
      end
    end
  end

  # DELETE /items/1
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    redirect_to items_url 
  end

end
