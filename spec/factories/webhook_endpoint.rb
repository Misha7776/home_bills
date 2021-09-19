FactoryBot.define do
  factory :webhook_endpoint do
    url { 'http://localhost:3000/webhooks' }
    subscriptions { ['events.test'] }
    enabled { true }
  end
end
