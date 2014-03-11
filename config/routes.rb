Game::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'
  resources :home, only: [] do
    get :search
  end

  get '/materials/wx_share' => 'materials#wx_share'
  get '/materials/report' => 'materials#report',  :as=>"report"

  get '/materials/hello_test' => 'materials#hello_test'

  resources :materials, only: [:index,:show] do
    collection do
      get :egg
    end
    member do
      get :return
      get :jiu_gong
    end
  end

  namespace :admin do
    get '/login' => 'session#new', as: :login
    root "home#index"
    resources :users
    resources :session
    resources :categories do
      member do
        get :clone
      end
    end
    resources :materials do
      resources :images, only: :new
      resources :answers, only: :new
      resources :questions, only: :new
      member do
        get :clone
        get :update_state
      end
    end
    resources :images, except: :new
    resources :answers, except: :new
    resources :questions, except: :new do
      resources :question_answers, only: :new
    end

    resources :question_answers, except: :new
  end
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
