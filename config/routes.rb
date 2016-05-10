Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:new, :create, :destroy, :update]
  end

  root "questions#index"
end
