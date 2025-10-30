Rails.application.routes.draw do
  get 'dashboard/index'
  root "dashboard#index" # Optional landing page

  resources :task_analysis, only: [:new] do
    collection do
      post :preview
      post :export
    end
  end

  resources :patient_tasks
  resources :demographics, except: [:index]
  resources :epilepsies, except: [:index]
  resources :ccep, except: [:index]
  resources :common_data_elements

end
