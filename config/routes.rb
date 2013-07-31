MoviesCucumbers::Application.routes.draw do
	root :to => 'home#index'
	devise_for :users

	resources :recommendations, only: [:index] 
	resources :ratings, only: [:index, :create, :update]

	get '/search' => 'ratings#search', as: 'search'

	get '/users/ratings' => 'users#ratings', as: 'user_ratings'

end
