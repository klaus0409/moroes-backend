Rails.application.routes.draw do
  apipie
  devise_for :users

  root 'welcome#index'

  resources :users

  resources :devices do
    resources :intents, only: :index
    resources :device_apps, shallow: true
  end
  resources :device_types
  resources :apps
  resources :museums
  resources :power_controllers
  resources :power_controller_ports, only: [:edit, :update]

  post 'start_devices' => "command#start_command"
  post 'stop_devices'  => "command#stop_command"
  post 'broadcast_message' => "command#broadcast_message"
  post 'start_app' => "command#start_app"


  namespace :api do
    namespace :v1 do

      resources :users, only: [] do
        post :signin, on: :collection
      end

      resources :museums, only: :show do
        resources :devices, only: :index
      end
      
      resources :apps, only: [:index, :show]

      resource :command, only: [] do
        post :start_devices
        post :stop_devices
        post :broadcast_message
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
