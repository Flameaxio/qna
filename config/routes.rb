Rails.application.routes.draw do
  get 'comments/create'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'questions#index'

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


  post '/comments/', to: 'comments#create_question_comment'

  mount ActionCable.server => '/cable'
end
