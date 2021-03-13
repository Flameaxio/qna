Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'questions#index'

  resources :questions do
    member do
      delete :remove_attachment
    end
    resources :answers do
      member do
        post :set_best
        patch :upvote
        patch :downvote
      end
    end
  end
end
