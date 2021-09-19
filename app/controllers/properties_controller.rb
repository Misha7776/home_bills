class PropertiesController < ApplicationController
  before_action :set_property, only: %i[show edit update destroy]

  def index
    @properties = current_user.properties
  end

  def show; end

  def new
    @property = Property.new
  end

  def edit; end

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

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit!
  end
end
