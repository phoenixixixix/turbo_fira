Rails.application.routes.draw do
  resources :tasks, except: %i[ show ]
  root "tasks#index"
end
