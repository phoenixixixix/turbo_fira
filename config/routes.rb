Rails.application.routes.draw do
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"

  post "log_in", to: "sessions#create"
  get "log_in", to: "sessions#new"

  delete "log_out", to: "sessions#destroy"

  resources :confirmations, only: %i(create edit new), param: :confirmation_token

  resources :stacks do
    resources :tasks, except: %i[ show ], shallow: true
  end
  root "stacks#index"
end
