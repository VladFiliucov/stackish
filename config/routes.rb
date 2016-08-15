Rails.application.routes.draw do
  resources :attachments, only: [:destroy]

  concern :votable do
    member do
      patch :change_rating
      delete :withdraw_rating
    end
  end

  devise_for :users
  resources :questions, concerns: :votable do
    resources :answers, only: [:new, :create, :destroy, :update], concerns: :votable do
      patch :mark_best, on: :member
    end
  end

  root "questions#index"
end
