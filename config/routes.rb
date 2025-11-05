Rails.application.routes.draw do
  resources :users do
    resources :data_repositories

    member do
      get :new_rppr
      post :create_rppr
      post :submit_rppr
      get :edit_rppr
      post :update_rppr
      delete :remove_rppr
      post :add_pi_delegate
    end
  end
  get 'welcome/index'
  get 'welcome/dashboard'
  get 'welcome/ut_cloud'
  get 'welcome/public_cloud'
  get '/landing/index'
  resources :sessions, only: [:new, :create, :destroy]
  get '/signin',  to: 'sessions#new'
  # get '/secure',  to: 'sessions#shib_new'
  get '/secure',  to: 'sessions#acs'
  post '/shib_auth',  to: 'sessions#shib_auth'
  delete '/signout', to: 'sessions#destroy'


  resources :roles do
    collection do
      post :update_all
    end
  end
  resources :projects do
  	collection do
  		get :reports
      post :upload_nih_awards
      post :get_rppr
      post :upload_dms_plan_file
    end
    member do
      get :print_dms_plan
      post :approve_rppr
      post :return_rppr
  	end
  end

  resources :rpprs, only: [:index] do
    member do
      post :update_dates
      post :create_comment
      get :new_comment
      get :edit_comment
      post :update_comment
    end
  end

  resources :data_repository_records do
    member do
      get :screenshot
    end
  end
get "logout" => "sessions#destroy", :as => "log_out"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root :to => "welcome#index"
  root :to => "landing#index"

  constraints lambda { |req| req.session["admin"] } do
    mount Logster::Web => "/logs"
  end

  resources :patients
  resources :terminologies
  get 'terminologies', to: 'patients#terminologies'
end
