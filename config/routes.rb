Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users

  authenticated do
    root to: "welcome#index", as: :authenticated_root
  end

  get 'welcome/index'

  get 'articles/my_articles', to: 'articles#my_articles'

  resources :articles do
    resources :comments
  end

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
