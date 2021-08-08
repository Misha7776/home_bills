require 'rails_helper'

module Mutations
  module Properties
    RSpec.describe Create, type: :request do
      describe '.resolve' do
        let!(:user) { create(:user, password: '123456') }

        context 'when params are valid' do
          let!(:property_attributes) { attributes_for(:property, user_id: user.id) }

          it 'should create a new property' do
            headers = { 'Authorization' => Base64.encode64(user.email) }
            post '/graphql', params: { query: query(params: property_attributes) }, headers: headers
            property = Property.find(json.dig('data', 'createProperty', 'property', 'id'))
            expect(property).to be_present
            expect(property.name).to eq(property_attributes[:name])
          end
        end

        context 'when params are invalid' do
          let!(:property_attributes) { attributes_for(:property, user_id: user.id) }

          it 'should not create a property' do
            post '/graphql', params: { query: invalid_query(params: property_attributes) }
            expect(json['errors'][0]['message']).to be_present
          end
        end
      end

      def query(params:)
        <<~GQL
          mutation {
            createProperty(
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
            createProperty(
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
  end
end
