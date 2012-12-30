# -*- encoding : utf-8 -*-
class ItemsController < ApplicationController
  respond_to :js, :only => [:create, :update, :destroy]

  # GET /items
  def index
    page_size   = 20 
    area_code   = params[:area] || ''
    xtype       = params[:xtype].to_i
    category_id = params[:category].to_i

    items_scope = Item.latest
    items_scope = items_scope.where(:category_id => category_id) if category_id > 0 
    items_scope = items_scope.where(:xtype => xtype) if xtype > 0 

    if not area_code.empty?
      code_name_ary = %w(province_code city_code county_code town_code village_code)
      code_level, code_prefix = ChineseRegion.get_level_and_prefix(area_code)
      items_scope = items_scope.where(" #{code_name_ary[code_level -1]} = ?", area_code)
    end

    prepare_items_condition_list(category_id, area_code, xtype)   

    @items = items_scope.page(params[:page]).per(page_size)
    
    drop_breadcrumb('产品', items_path)

    if @current_category_name.size > 0 
      drop_breadcrumb @current_category_name, condition_list_items_path(:category => category_id, :xtype => nil, :area => nil)
    end

    if @current_xtype_name.size > 0
      drop_breadcrumb @current_xtype_name, condition_list_items_path(:category => category_id, :xtype => xtype, :area => nil)
    end

    if @current_areas and @current_areas.size > 0
      @current_areas.each do |a| 
        drop_breadcrumb a.name, condition_list_items_path(:area => a.code, :category => category_id, :xtype => xtype)
      end
    end

    respond_to do |format|
      format.html { }
      format.mobile { }
    end
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
    @page_tiele = @item.title
    
    drop_breadcrumb('产品', items_path)
    drop_breadcrumb(@item.category.name, condition_list_items_path(:category => @item.category_id, :xtype => nil, :area => nil) )
    drop_breadcrumb(@item.xtype == 1 ? '供应':'求购', condition_list_items_path(:category => @item.category_id, :xtype => @item.xtype, :area => nil) )
    drop_breadcrumb(@item.province_name, condition_list_items_path(:area => @item.province_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.city_name, condition_list_items_path(:area => @item.city_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.county_name, condition_list_items_path(:area => @item.county_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.town_name, condition_list_items_path(:area => @item.town_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.village_name, condition_list_items_path(:area => @item.village_code, :category => @item.category_id, :xtype => @item.xtype ) )
    drop_breadcrumb(@item.title, item_path(@item) )

    prepare_items_condition_list(@item.category_id, @item.village_code, @item.xtype)
  end

  # GET /items/new
  def new
    @page_tiele = '发布'
    drop_breadcrumb("发布", new_item_path)

    @item = Item.new
    @provinces = ChineseRegion.provinces
  end

  # GET /items/1/edit
  def edit

    @item = Item.find(params[:id])
    drop_breadcrumb("编辑", edit_item_path(@item) )
    @page_tiele = '编辑' + @item.title

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
        format.mobile { redirect_to(@item)  }
      else
        format.js { render :layout => false }
        format.mobile {
          @provinces = ChineseRegion.provinces
          children_level, @cities = ChineseRegion.children(@item.province_code)
          children_level, @counties = ChineseRegion.children(@item.city_code)
          children_level, @towns = ChineseRegion.children(@item.county_code)
          children_level, @villages = ChineseRegion.children(@item.town_code)
          render 'new'
        }
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

  private 
  def prepare_items_condition_list(category_id, area_code, xtype)
    @current_params = {}
    @current_params[:area]     = area_code
    @current_params[:xtype]    = xtype
    @current_params[:category] = category_id 

    @categories = Category.all  
    @current_category_name = ''
    if category_id > 0
      @current_category = @categories.find{|x| x.id == category_id}
      @current_category_name = @current_category.name
    end

    @current_xtype_name = ''
    if xtype > 0
      @current_xtype_name = xtype == 1 ? "供应" : "求购"
    end

    if area_code.empty?
      @regions = ChineseRegion.provinces 
    else
      temp_level, @regions = ChineseRegion.children(area_code)
      @current_areas       = ChineseRegion.get_parents(area_code)
    end
  end
end
