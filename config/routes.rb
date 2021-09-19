require 'sidekiq/web'

Rails.application.routes.draw do
  resources :properties
  root to: 'properties#index'
  resources :webhook_endpoints
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/api/v1/graphql"
  end
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { registrations: "registrations" }
  post '/webhooks', to: proc { [204, {}, []] }

  namespace :api do
    namespace :v1 do
      post '/graphql', to: 'graphql#execute'
    end
  end
end
