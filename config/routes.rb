Rails.application.routes.draw do
devise_for :users


resources :users, only: [:index, :show] do
resources :follow_requests, only: [:create]
end


resources :follow_requests, only: [:index, :destroy] do
member do
patch :accept
patch :decline
end
end


resources :follows, only: [:destroy]


resources :posts do
resources :comments, only: [:create, :destroy]
resource :like, only: [:create, :destroy]
end


root 'posts#index'


if Rails.env.development?
mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
end