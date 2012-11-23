# -*- encoding : utf-8 -*-
class ItemsController < ApplicationController
  respond_to :js, :only => [:create, :update, :destroy]

  # GET /items
  def index
    category_id = params[:category].to_i
    xtype       = params[:xtype].to_i
    area_code   = params[:area] || ''

    items_scope = Item.where(' 1 = 1 ')
    items_scope = items_scope.where('category_id = ?', category_id) if category_id > 0 
    items_scope = items_scope.where('xtype = ?', xtype) if xtype > 0 

    if not area_code.empty?
      code_name_ary = %w(province_code city_code county_code town_code village_code)
      code_level, code_prefix = ChineseRegion.get_level_and_prefix(area_code)
      items_scope = items_scope.where(" #{code_name_ary[code_level -1]} = ?", area_code)
    end

    #@items = items_scope.includes(:category,:user)
    @items = items_scope.page params[:page]
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
        format.mobile{ redirect_to @item, :notice => "创建成功！" }
      else
        format.js { render :layout => false }
        format.mobile{ render 'new' }
      end
    end

  end

  # PUT /items/1
  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.js{ render :layout => false }
        format.mobile{ redirect_to @item, :notice => "编辑成功！" }
      else
        format.js{ render :layout => false }
        format.mobile{ render 'new' }
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
