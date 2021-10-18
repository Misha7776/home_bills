class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show edit update destroy]
  before_action :set_page_meta_tags, only: %i[index show new edit]

  def index
    @page_title = 'Listing properties'
    @properties = current_user.properties
  end

  def show
    @page_title = "Property - #{@property.name}"
  end

  def new
    @page_title = 'New property'
    @property = Property.new
  end

  def edit
    @page_title = "Edit #{@property.name}"
  end

  def create
    res = Properties::Operations::Create.call(record_params: property_params.merge!(user_id: current_user.id))
    @property = res.args[:record]
    if res.success?
      redirect_to @property, notice: 'Property was successfully created.'
    else
      render :new
    end
  end

  def update
    res = Properties::Operations::Update.call(record: @property, record_params: property_params)
    @property = res.args[:record]
    if res.success?
      redirect_to @property, notice: 'Property was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    Properties::Operations::Destroy.call(record: @property)
    redirect_to properties_url, notice: 'Property was successfully destroyed.'
  end

  private

  def set_page_meta_tags
    set_meta_tags title: @page_title, description: 'Member login page.', keywords: 'Site, Login, Members'
  end

  def set_property
    @property = Property.friendly.find(params[:id])
  end

  def property_params
    params.require(:property).permit!
  end
end
