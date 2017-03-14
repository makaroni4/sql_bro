Rails.application.routes.draw do
  root to: redirect("db/queries")

  namespace :db do
    resources :queries
  end
  namespace :db do
    resources :connections
  end
end
