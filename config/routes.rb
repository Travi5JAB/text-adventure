Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations'}
	devise_scope :user do
	end

  get '/profile/:id' => 'pages#profile'

  root to: 'pages#index'
end
