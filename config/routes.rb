Rails.application.routes.draw do
  resources :things
  post 'things/:id/create_instance', to: 'things#create_instance', as: :create_thing_instance
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "things#index"
end
