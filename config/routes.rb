MoviesCucumbers::Application.routes.draw do
	authenticated :user do
		root :to => 'home#index'
	end
	devise_for :users
	resources :users do 
		resources :ratings, shallow: true
		member do
			get 'recommendations'
			get 'watchlist'
			post 'watchlist'
			put 'watchlist'
			get 'favorites'
			post 'favorites'
			put 'favorites'
		end
	end

end