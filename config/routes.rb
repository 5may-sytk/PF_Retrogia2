Rails.application.routes.draw do
  namespace :admin do
    get 'post_comments/index'
  end
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    passwords:     'admin/passwords',
    sessions:      'admin/sessions',
    }, path_names: {
      sign_in: 'Log_in'
  }

  devise_for :users, skip: [:passwords], controllers: {
    passwords:     'public/passwords',
    registrations: 'public/registrations',
    sessions:      'public/sessions'
    }, path_names: {
      sign_in: 'Log_in'
  }

  devise_scope :user do
    get "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  namespace :admin do
    resources :users, only: [:index, :show, :update, :destroy] do
    resources :posts, only: [:index, :edit, :update, :destroy]  
    end
    get "search" => "searches#search"
  end

  scope module: :public do
    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: "followings"
      get "followers" => "relationships#followers", as: "followers"
      collection do
        get 'private_user'
        get 'confirmation'
        patch 'leave'
      end
      get "album" => "users#album"
    end

    resources :posts do
      resources :post_comments, only: [:index, :edit, :update, :create, :destroy]
      resource :bookmarks, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      resource :map, only: [:show] 
    end
      get "search" => "searches#search"
      get 'favorites/favorited'
      get 'bookmarks/bookmarked'
  end

  
  root to: "homes#top"
  get 'home/about' => 'homes#about', as:'about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
