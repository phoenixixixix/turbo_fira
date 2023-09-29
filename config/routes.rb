Rails.application.routes.draw do
  resources :stacks do
    resources :tasks, except: %i[ show ], shallow: true
  end
  root "stacks#index"
end
