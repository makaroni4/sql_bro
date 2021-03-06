Rails.application.routes.draw do
  root to: redirect("db/queries")

  namespace :db do
    resources :queries do
      collection do
        get :setup_autocomplete
        get :autocomplete
        get :cancel
        get :search
      end
    end
  end

  namespace :db do
    resources :connections do
      get :tables
      get :refresh_tables
    end
  end
end
