Rails.application.routes.draw do
  devise_for :companies, controllers: { sessions: 'companies/sessions',
  									registrations: 'companies/registrations',
  									passwords: 'companies/passwords'
  								}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'application#home', as: :root 

  resources :vehicles, except: :destroy
  delete 'vehicles/delete', to: 'vehicles#destroy', as: :delete_vehicle
  get 'list_vehicles', to: 'vehicles#list_vehicles', as: :list_vehicles  
  get 'vehicle/:id/list_histories', to: 'vehicles#list_vehicle_histories', as: :list_vehicle_histories 
  get 'refresh', to: 'vehicles#refresh', as: :refresh_vehicle   

  get 'company/profile', to: 'companies#profile', as: :company_profile  
  get 'company/edit', to: 'companies#edit', as: :edit_company
  patch 'company/update', to: 'companies#update', as: :update_company
  get 'company/edit_password', to: 'companies#edit_password', as: :edit_password  
  post 'update_password', to: 'companies#update_password', as: :update_password
end
