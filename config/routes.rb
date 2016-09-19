Rails.application.routes.draw do
  get 'comments/create'

  resources :attachments, only: [:destroy]

  concern :votable do
    member do
      patch :change_rating
      delete :withdraw_rating
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: {commentable: 'questions'}

    resources :answers, only: [:new, :create, :destroy, :update], concerns: :votable do
      resources :comments, only: :create, defaults: {commentable: 'answers'}
      patch :mark_best, on: :member
    end
  end

  root "questions#index"
end
