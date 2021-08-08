require 'rails_helper'

module Mutations
  module Users
    RSpec.describe SignInMutation, type: :request do
      describe '.resolve' do
        let!(:user) { create(:user, password: '123456') }

        context 'when credentials are correct' do
          it 'should return a sign in token' do
            post '/graphql', params: { query: query(email: user.email, password: user.password) }
            expect(json.dig('data', 'signIn')).to eq({ token: Base64.encode64(user.email),
                                                       user: {
                                                         id: user.id.to_s,
                                                         fullName: user.full_name
                                                       } }.as_json)
          end
        end

        context 'when params are wrong' do
          it 'should return empty response' do
            post '/graphql', params: { query: query(email: user.email, password: 'qwedfaqqwe') }
            expect(json.dig('data', 'signIn')).to eq({ token: nil, user: nil}.as_json)
          end
        end
      end

      def query(email:, password:)
        <<~GQL
          mutation {
            signIn(email: "#{email}", password: "#{password}") {
              token
              user {
                id
                fullName
              }
            }
          }
        GQL
      end
    end
  end
end