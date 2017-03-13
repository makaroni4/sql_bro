Rails.application.routes.draw do
  root to: "db/queries#index"

  namespace :db do
    resources :queries
  end
  namespace :db do
    resources :connections
  end
end
