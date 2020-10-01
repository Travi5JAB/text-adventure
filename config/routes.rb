Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations'}
	devise_scope :user do
	end



  resources :games do
    resources :ratings
    resources :reports
  end

  resources :pages
    get '/reportinfo/:id' => 'pages#reportinfo'
    get '/profile/:id' => 'pages#profile'
    get '/uploadmygame' => 'pages#newgame'
    get '/report/:id' => 'pages#report'
    get '/playhistory' => 'pages#playhistory'
    post 'add_comment' => 'pages#add_comment'
    post 'add_game' => 'pages#add_game'
    post 'add_report' => 'pages#add_report'
    post 'add_rating' => 'pages#add_rating'
    post 'add_visit' => 'pages#add_visit'

  root to: 'pages#index'
end
