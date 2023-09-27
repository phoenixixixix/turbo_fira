Rails.application.routes.draw do
  resources :tasks, except: :show
  root "tasks#index"
end
