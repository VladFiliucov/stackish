Rails.application.routes.draw do
  resources :attachments, only: [:destroy]

  concern :votable do
    member do
      patch :change_rating
    end
  end

  devise_for :users
  resources :questions, concerns: :votable do
    resources :answers, only: [:new, :create, :destroy, :update] do
      patch :mark_best, on: :member
    end
  end

  root "questions#index"
end
