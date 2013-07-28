MoviesCucumbers::Application.routes.draw do
	root :to => 'home#index'
	devise_for :users
	# authenticated :user do
	# 	root :to => 'home#index'
	# end

	resources :recommendations, only: [:index, :create, :new] 
	resources :ratings, only: [:index, :new, :create, :edit, :update]


	resources :user, only: [:index, :show]

	get '/users/ratings' => 'users#ratings', as: 'user_ratings'

	# resources :favorites, only: [:index, :new, :create, :edit, :update]
	# resources :watch_list, only: [:index, :new, :create, :edit, :update]

	
	
end
