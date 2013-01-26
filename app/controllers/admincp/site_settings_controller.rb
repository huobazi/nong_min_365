# -*- encoding : utf-8 -*-
class Admincp::SiteSettingsController < Admincp::ApplicationController
  # GET /admincp/site_settings
  # GET /admincp/site_settings.json
  def index
    @site_settings = ::SiteSettings
        .where('thing_id is null and thing_type is null')
        .order(' id asc ')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @site_settings }
    end
  end

  # GET /admincp/site_settings/1
  # GET /admincp/site_settings/1.json
  def show
    @site_setting = ::SiteSettings.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @site_setting }
    end
  end

  # GET /admincp/site_settings/new
  # GET /admincp/site_settings/new.json
  def new
    @site_setting = ::SiteSettings.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @site_setting }
    end
  end

  # GET /admincp/site_settings/1/edit
  def edit
    @site_setting = ::SiteSettings.find(params[:id])
  end

  # POST /admincp/site_settings
  # POST /admincp/site_settings.json
  def create
    @site_setting = ::SiteSettings.new(params[:site_settings])

    respond_to do |format|
      if @site_setting.save
        ::SiteSettings[@site_setting.var] = YAML::load(@site_setting.value)
        format.html { redirect_to admincp_site_setting_path(@site_setting), notice: 'Site setting was successfully created.' }
        format.json { render json: @site_setting, status: :created, location: @site_setting }
      else
        format.html { render action: "new" }
        format.json { render json: @site_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admincp/site_settings/1
  # PUT /admincp/site_settings/1.json
  def update
    @site_setting = ::SiteSettings.find(params[:id])

    respond_to do |format|
      if @site_setting.update_attributes(params[:site_settings])
        ::SiteSettings[@site_setting.var] = YAML::load(@site_setting.value)
        format.html { redirect_to admincp_site_setting_path( @site_setting ), notice: 'Site setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @site_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admincp/site_settings/1
  # DELETE /admincp/site_settings/1.json
  def destroy
    @site_setting = ::SiteSettings.find(params[:id])
    @site_setting.destroy

    respond_to do |format|
      format.html { redirect_to admincp_site_settings_url }
      format.json { head :no_content }
    end
  end
end
