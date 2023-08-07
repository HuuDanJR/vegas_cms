Rails.application.routes.draw do
  devise_for :user, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations',
      unlocks: 'users/unlocks',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get '/404', to: 'application#redirect_to_not_found'
  get '/422', to: 'application#redirect_to_unprocessable'
  get '/500', to: 'application#redirect_to_500_error'
  get 'admin' => redirect('/dashboard')
  get 'dashboard', to: 'dashboard#index'
  get 'home', to: 'home#index'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :attachments, only: [:download] do
        collection do
          get '/download/:id', to: 'attachments#download', constraints: {:id => /\d+/}
        end
      end
      resources :officers, only: [:index, :show]
      resources :roulettes, only: [:index, :show]
    end
  end
  resources :attachments do
    collection do
      get 'download/:id', to: 'attachments#download', constraints: {:id => /\d+/}
    end
  end
  resources :groups do
    collection do
      get ':id/edit_role', to: 'groups#edit_role', constraints: {:id => /\d+/}
      patch ':id/edit_role', to: 'groups#update_role', constraints: {:id => /\d+/}
    end
  end
  resources :officer_imports
  resources :officers do
    collection do
      get 'export', to: 'officers#export'
    end
  end
  resources :roles
  resources :roulettes do
    collection do
      get 'export', to: 'roulettes#export'
    end
  end
  resources :users do
    collection do
      get ':id/activated', to: 'users#activate', constraints: {:id => /\d+/}
      get ':id/change-password', to: 'users#change_password', constraints: {:id => /\d+/}
      post ':id/change-password', to: 'users#execute_change_password', constraints: {:id => /\d+/}
      get ':id/reset-password', to: 'users#reset_password', constraints: {:id => /\d+/}
      get ':id/locked', to: 'users#lock', constraints: {:id => /\d+/}
      get ':id/unlocked', to: 'users#unlock', constraints: {:id => /\d+/}
    end
  end
  resources :zone_imports
  resources :zones do
    collection do
      get 'export', to: 'zones#export'
    end
  end
  root to: 'home#index'
  use_doorkeeper_openid_connect
  use_doorkeeper
  match '*path', to: 'application#redirect_to_not_found', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
