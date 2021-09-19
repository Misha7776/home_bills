require 'rails_helper'

RSpec.describe Users::Mutations::SignUp, type: :request do
  describe '.resolve' do
    let!(:user_attributes) { attributes_for(:user, password: '123456') }

    context 'when credentials are correct' do
      it 'should return a sign in token' do
        post '/api/v1/graphql', params: { query: query(email: user_attributes[:email],
                                                       password: user_attributes[:password],
                                                       first_name: user_attributes[:first_name], last_name: user_attributes[:last_name],
                                                       password_confirmation: user_attributes[:password]) }
        expect(json.dig('data', 'signUp')).to eq({ token: Base64.encode64(user_attributes[:email]),
                                                   errors: nil,
                                                   user: {
                                                     id: User.last.id.to_s,
                                                     fullName: [user_attributes[:first_name], user_attributes[:last_name]].compact.join(' ')
                                                   } }.as_json)
      end
    end

    context 'when params are wrong' do
      let!(:errors) { ["Password confirmation can't be blank", "Password confirmation can't be blank"] }
      it 'should return empty response' do
        post '/api/v1/graphql', params: { query: query(email: user_attributes[:email], password: 'qwedfaqqwe',
                                                       first_name: 'User', last_name: '',
                                                       password_confirmation: '') }
        expect(json.dig('data', 'signUp')).to eq({ token: nil, user: nil, errors: errors }.as_json)
      end
    end
  end

  def query(email:, password:, first_name:, last_name:, password_confirmation:)
    <<~GQL
      mutation {
        signUp(email: "#{email}", firstName: "#{first_name}", lastName: "#{last_name}", password: "#{password}", passwordConfirmation: "#{password_confirmation}") {
          token
          errors
          user {
            id
            fullName
          }
        }
      }
    GQL
  end
end
