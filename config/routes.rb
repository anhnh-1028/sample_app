Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    # static_pages
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    # users
    get "/signup", to: "users#new"
    get ":id/following", to: "following#index", as: "following"
    get ":id/follower", to: "follower#index", as: "follower"
    resources :users, except: :new
    # sessions
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    #account_activations
    resources :account_activations, only: :edit
    #password__resets
    resources :password_resets, except: %i(show index destroy)
    #microposts
    resources :microposts, only: %i(create destroy)
    #relationship
    resources :relationships, only: %i(create destroy)
  end
end
