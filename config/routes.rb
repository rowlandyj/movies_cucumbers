MoviesCucumbers::Application.routes.draw do
	root :to => 'home#index'
	devise_for :users

	resources :recommendations, only: [:index, :create, :new] 
	resources :ratings, only: [:index, :new, :create, :edit, :update]

	get '/search' => 'ratings#search', as: 'search'

	get '/users/ratings' => 'users#ratings', as: 'user_ratings'

end
