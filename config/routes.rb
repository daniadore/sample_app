Rails.application.routes.draw do
  get 'sessions/new'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'static_pages#home', as: 'home'
    get 'static_pages/help', as: 'help'
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: %i(show new create)
    get 'home/index'
    resources :posts
  end
end
