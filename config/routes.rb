Rails.application.routes.draw do
  devise_for :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  scope module: :customers do
    resource :account, only: :show

    resources :transactions, only: %i[new create]
  end

  # Defines the root path route ("/")
  root "customers/account#show"
end
