Rails.application.routes.draw do
  
  devise_for :users
  # API definitions
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api'}, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update]
    end
  end  
end
