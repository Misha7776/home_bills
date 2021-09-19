# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WebhookEndpointsController do
  describe 'POST /api/v1/webhook_endpoints' do
    let!(:user) { create(:user) }
    let!(:params) do
      { webhook_endpoint: { url: 'http://localhost:3000/webhooks',
                            subscriptions: ['events.test'],
                            enabled: false } }
    end

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context 'with valid params' do
      it 'should create new webhook endpoint' do
        post :create, params: params
        created_listing = WebhookEndpoints.last
        expect(created_listing.enabled).to eq params[:webhook_endpoint][:enabled]
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PUT /listing/:id/mark_as_competitor' do
    let!(:user) { create(:user) }
    let!(:listing) { create(:listing) }
    let!(:params) { { listing: { competitor: 1 }, id: listing.id } }

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context 'with valid params' do
      it 'should mark the listing as a competitor' do
        put :mark_as_competitor, params: params
        updated_listing = listing.reload
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(ranking_path(updated_listing))
        expect(updated_listing.competitor).to eq true
        expect(updated_listing.journals).to be_present
      end
    end
  end
end
