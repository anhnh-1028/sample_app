Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # static_pages
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    # users
    get "/signup", to: "users#new"
    resources :users, except: :new
    # sessions
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    #account_activations
    resources :account_activations, only: :edit
  end
end
