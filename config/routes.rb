Rails.application.routes.draw do

  resources :articles
  root 'shikai_shosetu_bot#index'
  
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
