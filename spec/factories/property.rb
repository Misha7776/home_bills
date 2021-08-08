FactoryBot.define do
  factory :property do
    name { Faker::Lorem.word.upcase }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    notes { Faker::Lorem.sentence }
    user
  end
end
