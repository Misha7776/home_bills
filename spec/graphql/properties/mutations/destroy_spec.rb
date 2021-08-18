require 'rails_helper'

RSpec.describe Properties::Mutations::Destroy, type: :request do
  describe '.resolve' do
    let!(:user) { create(:user, password: '123456') }

    context 'when params are valid' do
      let!(:property) { create(:property, user_id: user.id) }
      let!(:valid_params) do
        { id: property.id }
      end

      it 'should create a new property' do
        headers = { 'Authorization' => Base64.encode64(user.email) }
        post '/graphql', params: { query: query(params: valid_params) }, headers: headers
        expect(Property.find_by(id: property.id)).not_to be_present
      end
    end

    context 'when params are invalid' do
      let!(:invalid_params) do
        { id: 999 }
      end

      it 'should not create a property' do
        headers = { 'Authorization' => Base64.encode64(user.email) }
        expect { post '/graphql', params: { query: invalid_query(params: invalid_params) }, headers: headers }
          .to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  def query(params:)
    <<~GQL
      mutation {
        destroyProperty(id: #{params[:id]}) {
          property {
           id
           name
           address
           city
           notes
           userId
          }
        }
      }
    GQL
  end

  def invalid_query(params:)
    <<~GQL
      mutation {
        destroyProperty(id: #{params[:id]}) {
          property {
           id
           name
           address
           city
           notes
           userId
          }
        }
      }
    GQL
  end
end
