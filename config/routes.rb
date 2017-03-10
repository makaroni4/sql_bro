Rails.application.routes.draw do
  namespace :db do
    resources :connections
  end
end
