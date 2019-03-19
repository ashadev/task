Rails.application.routes.draw do
	namespace :api, constraints: { format: 'json' } do
    	namespace :v1 do
    		resources :todos
    		resources :logs, only: [:index, :show]
    	end
    end
end
