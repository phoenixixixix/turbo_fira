Rails.application.routes.draw do
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"

  resources :stacks do
    resources :tasks, except: %i[ show ], shallow: true
  end
  root "stacks#index"
end
