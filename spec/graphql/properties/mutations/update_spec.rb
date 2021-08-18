require 'rails_helper'

RSpec.describe Properties::Mutations::Update, type: :request do
  describe '.resolve' do
    let!(:user) { create(:user, password: '123456') }

    context 'when params are valid' do
      let!(:property) { create(:property, user_id: user.id) }
      let!(:valid_params) do
        { name: 'New Name',
          address: 'New Address',
          city: 'New city',
          notes: 'New notes',
          id: property.id }
      end

      it 'should create a new property' do
        headers = { 'Authorization' => Base64.encode64(user.email) }
        post '/graphql', params: { query: query(params: valid_params) }, headers: headers
        property = Property.find(json.dig('data', 'updateProperty', 'property', 'id'))
        expect(property).to be_present
        expect(property.name).to eq(valid_params[:name])
        expect(property.address).to eq(valid_params[:address])
      end
    end

    context 'when params are invalid' do
      let!(:property) { create(:property, user_id: user.id) }
      let!(:invalid_params) do
        { address: 'New Address',
          city: 'New city',
          notes: 'New notes' }
      end

      it 'should not create a property' do
        post '/graphql', params: { query: invalid_query(params: invalid_params) }
        expect(json['errors'][0]['message']).to be_present
      end
    end
  end

  def query(params:)
    <<~GQL
      mutation {
        updateProperty(id: #{params[:id]},
          name: "#{params[:name]}",
          address: "#{params[:address]}",
          city: "#{params[:city]}",
          notes: "#{params[:notes]}") {
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
        updateProperty(
          address: "#{params[:address]}",
          city: "#{params[:city]}",
          notes: "#{params[:notes]}") {
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
