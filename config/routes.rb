Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:index, :new, :create, :destroy] do
    end
  end

  root "questions#index"
end
