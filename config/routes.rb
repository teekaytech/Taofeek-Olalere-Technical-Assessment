Rails.application.routes.draw do
  devise_for :users,
        controllers: {
          sessions: 'users/sessions',
          registrations: 'users/registrations'
        },
        defaults: { format: :json }
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :events
      resources :tickets, only: %i[ create show ]
      get 'users/:id/events', to: 'events#user_events'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
