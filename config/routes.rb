Rails.application.routes.draw do

  get 'memo/index'
  resources :articles
  root 'shikai_shosetu_bot#index'
  
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
