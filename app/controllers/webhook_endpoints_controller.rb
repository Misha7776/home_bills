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
    @webhook_endpoint = WebhookEndpoint.new(webhook_endpoint_params)

    if @webhook_endpoint.save
      redirect_to @webhook_endpoint, notice: 'Webhook endpoint was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /webhook_endpoints/1
  def update
    if @webhook_endpoint.update(webhook_endpoint_params)
      redirect_to @webhook_endpoint, notice: 'Webhook endpoint was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /webhook_endpoints/1
  def destroy
    @webhook_endpoint.destroy
    redirect_to webhook_endpoints_url, notice: 'Webhook endpoint was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webhook_endpoint
      @webhook_endpoint = WebhookEndpoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def webhook_endpoint_params
      params.require(:webhook_endpoint).permit(:url, :subscriptions, :enabled, :user_id)
    end
end
