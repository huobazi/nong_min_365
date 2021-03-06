# -*- encoding : utf-8 -*-
class ItemsController < ApplicationController
  load_and_authorize_resource
  respond_to :js, :only => [:create, :update, :destroy]

  # GET /items
  def index
    @page_title = "产品"
    page_size   = 20
    page_index  = params[:page]
    area_code   = params[:area] || ''
    xtype       = params[:xtype].to_i
    category_id = params[:category].to_i

    items_scope = Item.latest
    if category_id > 0
      items_scope = items_scope.where('category_id = :category_id or category2_id = :category2_id',
                                      {category_id: category_id, category2_id: category_id}
                                     )

      category = Category.find category_id
    end
    items_scope = items_scope.where(:xtype => xtype) if xtype > 0 

    if not area_code.empty?
      code_name_ary = %w(province_code city_code county_code town_code village_code)
      code_level, code_prefix = ChineseRegion.get_level_and_prefix(area_code)
      items_scope = items_scope.where(" #{code_name_ary[code_level - 1]} = ?", area_code)
    end

    if category
      prepare_items_condition_list(category_id, area_code, xtype)
    else
      prepare_items_condition_list(nil, area_code, xtype)
    end

    @items = items_scope.page(page_index).per(page_size)

    drop_breadcrumb(@page_title, items_path)

    if @current_category_name.size > 0
      @page_title = "#{@current_category_name} #{@page_title}"
      drop_breadcrumb @current_category_name, condition_list_items_path(:category => category_id, :xtype => nil, :area => nil)
    end

    if @current_xtype_name.size > 0
      @page_title = "#{@current_xtype_name} #{@page_title}"
      drop_breadcrumb @current_xtype_name, condition_list_items_path(:category => category_id, :xtype => xtype, :area => nil)
    end

    if @current_areas and @current_areas.size > 0
      #@page_title = @current_areas[-1].name + "/#{@page_title}"
      @page_title = @current_areas.map{ |x| x.name }.join(' ') + " #{@page_title}"
      @current_areas.each do |a| 
        drop_breadcrumb a.name, condition_list_items_path(:area => a.code, :category => category_id, :xtype => xtype)
      end
    end

    @page_title = "#{@page_title} 第#{page_index ? page_index.to_i : 1}页"

    fresh_when(:etag => [@items.map{ |x|x.updated_at }, page_size, page_index, area_code, xtype, category_id])

    respond_to do |format|
      format.html { }
      format.mobile { }
    end
  end

  # GET /items/1
  def show
    @item = Item.find(params[:id])
    if params[:id] != @item.to_param
      headers["Status"] = "301 Moved Permanently"
      redirect_to item_url(@item), :status => 301
    end
    xtype_text = @item.xtype == 1 ? '供应':'求购'
    @page_title = "#{@item.province_name}#{@item.city_name}#{@item.county_name}的#{@item.contact_name}#{xtype_text}#{@item.title}#{@item.amount}"

    drop_breadcrumb('产品', items_path)
    drop_breadcrumb(@item.category.name, condition_list_items_path(:category => @item.category_id, :xtype => nil, :area => nil) )
    drop_breadcrumb(xtype_text, condition_list_items_path(:category => @item.category_id, :xtype => @item.xtype, :area => nil) )
    drop_breadcrumb(@item.province_name, condition_list_items_path(:area => @item.province_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.city_name, condition_list_items_path(:area => @item.city_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.county_name, condition_list_items_path(:area => @item.county_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.town_name, condition_list_items_path(:area => @item.town_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.village_name, condition_list_items_path(:area => @item.village_code, :category => @item.category_id, :xtype => @item.xtype ) )
    drop_breadcrumb(@item.title, item_path(@item) )

    if @item.category2_id
      prepare_items_condition_list(@item.category2_id, @item.village_code, @item.xtype)
    else
      prepare_items_condition_list(@item.category_id, @item.village_code, @item.xtype)
    end

    Item.increment_counter(:visit_count , @item.id) if ! params[:recall]

    fresh_when(:etag => [@item], :last_modified => @item.updated_at)
  end

  # GET /items/new
  def new
    @page_title = '发布产品'
    drop_breadcrumb(@page_title, new_item_path)

    @item = Item.new
    @provinces = ChineseRegion.provinces
    @categories = Category.roots

    fresh_when
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    drop_breadcrumb('产品', items_path)
    drop_breadcrumb(@item.category.name, condition_list_items_path(:category => @item.category_id, :xtype => nil, :area => nil) )
    drop_breadcrumb(@item.xtype == 1 ? '供应':'求购', condition_list_items_path(:category => @item.category_id, :xtype => @item.xtype, :area => nil) )
    drop_breadcrumb(@item.province_name, condition_list_items_path(:area => @item.province_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.city_name, condition_list_items_path(:area => @item.city_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.county_name, condition_list_items_path(:area => @item.county_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.town_name, condition_list_items_path(:area => @item.town_code, :category => @item.category_id, :xtype => @item.xtype) )
    drop_breadcrumb(@item.village_name, condition_list_items_path(:area => @item.village_code, :category => @item.category_id, :xtype => @item.xtype ) )

    drop_breadcrumb(@item.title, item_path(@item) )

    if @item.tag_list.include? "#{@item.province_name}"
      @item.tag_list.remove "#{@item.province_name}"
    end

    @page_title               = '编辑' + @item.title
    @provinces                = ChineseRegion.provinces
    children_level, @cities   = ChineseRegion.children(@item.province_code)
    children_level, @counties = ChineseRegion.children(@item.city_code)
    children_level, @towns    = ChineseRegion.children(@item.county_code)
    children_level, @villages = ChineseRegion.children(@item.town_code)


    @categories = Category.roots
  end

  # POST /items
  def create
    @item         = Item.new(params[:item])
    @item.ip      = request.remote_ip
    @item.user_id = signed_in? ? current_user.id : 0

    respond_to do |format|
      if @item.save
        format.js { render :layout => false }
        format.mobile { redirect_to @item, :notice => '创建成功！' }
      else
        format.js { render :layout => false }
        format.mobile {
          @provinces                = ChineseRegion.provinces
          children_level, @cities   = ChineseRegion.children(@item.province_code)
          children_level, @counties = ChineseRegion.children(@item.city_code)
          children_level, @towns    = ChineseRegion.children(@item.county_code)
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
      params[:item].delete(:user_id)
      if @item.update_attributes(params[:item])
        format.js{ render :layout => false }
        format.mobile{ redirect_to @item, :notice => "编辑成功！" }
      else
        format.js{ render :layout => false }
        format.mobile{ 
          @provinces                = ChineseRegion.provinces
          children_level, @cities   = ChineseRegion.children(@item.province_code)
          children_level, @counties = ChineseRegion.children(@item.city_code)
          children_level, @towns    = ChineseRegion.children(@item.county_code)
          children_level, @villages = ChineseRegion.children(@item.town_code)
          render 'edit'
        }
      end
    end
  end

  # DELETE /items/1
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    redirect_to items_url 
  end

  def tag
    if params[:tag]
      tag         = params[:tag]
      page_index  = params[:page]
      @page_title = "标签:#{tag}"
      page_size   = 20

      prepare_items_condition_list(0, '', 0)

      drop_breadcrumb(@page_title, items_tags_path(tag))
      @items = Item.latest.tagged_with(tag).page(page_index).per(page_size)
      @page_title = "#{@page_title} 第#{page_index ? page_index.to_i : 1}页"

      fresh_when(:etag => [@items.map{ |x|x.updated_at }, tag, page_index, page_size])
    else
      redirect_to items_path and return
    end
  end

  def tag_cloud

  end

  def show_hits
    @item = Item.find(params[:id])
    response.headers['X-NM365-Item-Hits'] = @item.visit_count.to_s
    render :text => ''
  end

  def refresh 
    @item = Item.find(params[:id])

    respond_to do |wants|
      if @item.update_attribute('refresh_at', Time.now.to_i )
        flash[:notice] = '信息刷新成功！'
        wants.html { redirect_to(@item) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "show" }
        wants.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def prepare_items_condition_list(category_id, area_code, xtype)
    @current_params = {}
    @current_params[:area]     = area_code
    @current_params[:xtype]    = xtype

    @all_categories = Category.get_cached_all
    @categories = Category.roots
    @category = @all_categories.find{|x| x.id == category_id}

    @current_category_name = ''
    @current_category2_name = ''
    if @category
      if @category.root?
        @current_category = @category
        @current_params[:category] = @category.id
      else
        @current_category = @category.parent
        @current_category2 = @category
        @current_category2_name = @current_category2.name
        @current_params[:category] = @current_category.id
        @current_params[:category2] = @current_category2.id
      end
      @current_category_name = @current_category.name
      @category2_list = @current_category.children
    end

    @current_xtype_name = ''
    if xtype && xtype > 0
      @current_xtype_name = xtype == 1 ? "供应" : "求购"
    end

    if area_code && area_code.empty?
      @regions = ChineseRegion.get_cached_all_province
    else
      temp_level, @regions = ChineseRegion.children(area_code)
      @current_areas       = ChineseRegion.get_parents(area_code)
    end
  end
end
