require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
 mount Sidekiq::Web => '/sidekiq'
 devise_for :users

 # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
