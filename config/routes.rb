Rails.application.routes.draw do
  resources :attachments, only: [:destroy]

  devise_for :users
  resources :questions do
    resources :answers, only: [:new, :create, :destroy, :update] do
      patch :mark_best, on: :member
    end
  end

  root "questions#index"
end
