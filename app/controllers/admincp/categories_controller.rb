# -*- encoding : utf-8 -*-
class Admincp::CategoriesController < Admincp::ApplicationController
  # GET /admincp/categories
  # GET /admincp/categories.json
  def index
    @categories = ::Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /admincp/categories/1
  # GET /admincp/categories/1.json
  def show
    @category = ::Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /admincp/categories/new
  # GET /admincp/categories/new.json
  def new
    @category = ::Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /admincp/categories/1/edit
  def edit
    @category = ::Category.find(params[:id])
  end

  # POST /admincp/categories
  # POST /admincp/categories.json
  def create
    @category = ::Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to admincp_category_path(@category), notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admincp/categories/1
  # PUT /admincp/categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to admincp_category_path(@category), notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admincp/categories/1
  # DELETE /admincp/categories/1.json
  def destroy
    @category = ::Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to admincp_categories_url }
      format.json { head :no_content }
    end
  end

  def sort_up 
    @category = ::Category.find(params[:id])
    @category.sort -= 1;
    @category.save

    respond_to do |format|
      format.html { redirect_to admincp_categories_url }
      format.json { head :no_content }
    end
  end

  def sort_down
    @category = ::Category.find(params[:id])
    @category.sort += 1;
    @category.save

    respond_to do |format|
      format.html { redirect_to admincp_categories_url }
      format.json { head :no_content }
    end
  end

end
