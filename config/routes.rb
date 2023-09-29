Rails.application.routes.draw do
  resources :stacks
  resources :tasks, except: %i[ show ]
  root "tasks#index"
end
