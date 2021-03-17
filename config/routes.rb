Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'questions#index'

  get 'users/authorize/new', to: 'users#new_authorized'
  post 'users/authorize/create', to: 'users#create_authorized'

  resources :questions do
    post :comment_question, to: 'comments#comment_question'
    member do
      delete :remove_attachment
    end
    resources :answers do
      post :comment_answer, to: 'comments#comment_answer'
      member do
        post :set_best
        patch :upvote
        patch :downvote
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :all, on: :collection
      end
    end
  end


  mount ActionCable.server => '/cable'
end
