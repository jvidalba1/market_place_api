Rails.application.routes.draw do
  
  # API definitions
  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api'}, path: '/' do
    # Resources
  end  
end
