class WebhookEndpointsController < ApplicationController
  before_action :set_webhook_endpoint, only: [:show, :edit, :update, :destroy]

  # GET /webhook_endpoints
  def index
    @webhook_endpoints = WebhookEndpoint.all
  end

  # GET /webhook_endpoints/1
  def show
  end

  # GET /webhook_endpoints/new
  def new
    @webhook_endpoint = WebhookEndpoint.new
  end

  # GET /webhook_endpoints/1/edit
  def edit
  end

  # POST /webhook_endpoints
  def create
    if (res = WebhookEndpoints::Operations::Create.call(record_params: webhook_endpoint_params)).success?
      @webhook_endpoint = res.args[:record]
      binding.pry
      redirect_to @webhook_endpoint, notice: 'Webhook endpoint was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /webhook_endpoints/1
  def update
    if (res = WebhookEndpoints::Operations::Update.call(record_params: webhook_endpoint_params,
                                                        record: @webhook_endpoint)).success?
      @webhook_endpoint = res.args[:record]
      redirect_to @webhook_endpoint, notice: 'Webhook endpoint was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /webhook_endpoints/1
  def destroy
    WebhookEndpoints::Operations::Destroy.call(record: @webhook_endpoint)
    redirect_to webhook_endpoints_url, notice: 'Webhook endpoint was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_webhook_endpoint
    @webhook_endpoint = WebhookEndpoint.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def webhook_endpoint_params
    params.require(:webhook_endpoint).permit!
  end
end
