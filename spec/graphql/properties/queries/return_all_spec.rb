require 'rails_helper'

RSpec.describe Types::QueryType do
  describe 'properties' do
    let!(:properties) { create_pair(:property) }

    let(:query) do
      %(query {
        properties {
          name
          address
          city
        }
      })
    end

    subject(:result) do
      HomeBillsSchema.execute(query).as_json
    end

    it 'returns all items' do
      expect(result.dig('data', 'properties')).to match_array(
        properties.map { |property| { 'name' => property.name, 'address' => property.address, 'city' => property.city } }
      )
    end
  end

  describe 'properties with users' do
    let!(:properties) { create_pair(:property) }

    let(:query) do
      %(query {
        properties {
          name
          address
          city
          user {
            id
            email
          }
        }
      })
    end

    subject(:result) do
      HomeBillsSchema.execute(query).as_json
    end

    it 'returns all items with users' do
      expect(result.dig('data', 'properties')).to match_array(
        properties.map do |property|
          { 'name' => property.name,
            'address' => property.address,
            'city' => property.city,
            'user' => {
              'id' => property.user.id.to_s,
              'email' => property.user.email
            }
          }
        end
      )
    end
  end
end
