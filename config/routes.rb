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

  namespace :api do
    namespace :v1 do
      post '/webhooks', to: proc { [204, {}, []] }
      post '/graphql', to: 'graphql#execute'
    end
  end

  get 'health_check', to: 'health_checks#check'
  match '(*any)', to: redirect(subdomain: ''), via: :all, constraints: {subdomain: 'www'}
  # get '/:id', to: 'properties#show', as: 'property'
  get "sitemap.xml" => "home#sitemap", format: :xml, as: :sitemap
  get "robots.txt" => "home#robots", format: :text, as: :robots
end
