Rails.application.routes.draw do
  # Devise authentication
  devise_for :users

  # Users
  resources :users, only: [:index, :show] do
    resources :follow_requests, only: [:create]
  end

  # Follow requests
  resources :follow_requests, only: [:index, :destroy] do
    member do
      patch :accept
      patch :decline
    end
  end

  # Follows (for unfollowing)
  resources :follows, only: [:destroy]

  # Posts + nested comments + likes
resources :posts do
  resources :comments, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy] 
end


  # Root path → feed
  root "posts#index"

  # Letter Opener Web (dev only)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
