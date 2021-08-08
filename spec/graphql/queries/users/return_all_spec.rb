require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'Users' do
    let!(:users) { create_pair(:user) }

    let(:query) do
      %(query {
        users {
          id
          email
          firstName
          lastName
          encryptedPassword
          createdAt
          updatedAt
        }
      })
    end

    subject(:result) do
      HomeBillsSchema.execute(query).as_json
    end

    it 'returns all users' do
      expect(result.dig('data', 'users')).to match_array(
        users.map do |user|
          { 'id' => user.id.to_s,
            'email' => user.email,
            'firstName' => user.first_name,
            'lastName' => user.last_name,
            'encryptedPassword' => user.encrypted_password,
            'createdAt' => user.created_at.utc.iso8601,
            'updatedAt' => user.updated_at.utc.iso8601 }.as_json
        end
      )
    end
  end
end
