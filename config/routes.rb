Rails.application.routes.draw do

  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
    end
  end

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

  get 'terms_and_conditions', to: 'user_agreements#terms_and_conditions'
  get 'policies', to: 'user_agreements#policies'

  root "questions#index"
end
