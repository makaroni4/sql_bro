Rails.application.routes.draw do
  root to: redirect("db/queries")

  namespace :db do
    resources :queries do
      collection do
        get :setup_autocomplete
        get :autocomplete
        get :cancel
      end
    end
  end

  namespace :db do
    resources :connections
  end
end
