Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: [:new, :create, :destroy, :update] do
      member do
        patch 'mark_best' => 'answers#mark_best'
      end
    end
  end

  root "questions#index"
end
