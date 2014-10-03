Game::Application.routes.draw do
  resources :wx_configs

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #get "games/toplist" => "home#redirect"

  #namespace :qq do
  #  root to: "welcome#index"
  #  get "welcome/load" => "welcome#load"
  #  get "welcome/recent_material" => "welcome#recent_material"
  #  get "welcome/hot_material" => "welcome#hot_material"
  #  get "welcome/test" => "welcome#test"
  #end

  #root :to => 'home#index', :as => "root"
  #root :to => redirect("/weitest/875161620")

  get '/', to: 'home#read', constraints: {subdomain: 't'}, as: 'read_root'
  get '/',  to: "home#index", as: 'default_root'

  resources :home, only: [] do
    get :search
  end

  get '/r' => 'home#r'
  get '/read' => 'home#read'
  get '/list/:type' => 'home#index'
  get '/add_weixin_url' => "home#add_weixin_url"

  get '/weitest/:material_id/result' => "weitest#result"

  #get '/weitest/gabrielecirulli' => 'weitest#gabrielecirulli'
  get '/weitest/wx_share' => 'weitest#wx_share'
  get '/weitest/report' => 'weitest#report',  :as=>"report"
  get '/weitest/stat' => 'weitest#stat',  :as=>"stat"

  get '/weitest/hello_test' => 'weitest#hello_test'

  resources :materials, only: [:show] do
    collection do
      get :egg
    end
    member do
      get :return
      get :jiu_gong
    end
  end

  resources :weitest, only: [:show] do
    collection do
      get :egg
    end
    member do
      get :return
      get :jiu_gong
    end
  end

  get '/:dd/weitest/:id/' => "weitest#show"
  get '/w/:sid/:id' => "weitest#show"
  get '/s/:sid/:id' => "weitest#show"

  #get '/qq/layouts/:layouts/material_id/:material_id' => "qq/welcome#index"
  #get '/qq/material_id/:material_id' => "qq/welcome#index"

  namespace :admin do
    get '/login' => 'session#new', as: :login
    #root "home#index"

    get 'home/clear_single_cache/:id' => "home#clear_single_cache"

    resources :weixins
    resources :domains

    resources :game_types
    resources :banners

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
        get :recommend_to_qq
        get :recommend_game
      end
    end
    resources :ads
    resources :images, except: :new
    resources :answers, except: :new
    resources :questions, except: :new do
      resources :question_answers, only: :new
    end

    resources :question_answers, except: :new

    get '/show_stat' => 'ads#show_stat', as: :show_stat
    get '/click_stat' => 'ads#click_stat', as: :click_stat
  end

  #namespace :custom do

  #  get '/login' => 'session#new', as: :login

  #  root "welcome#index"
  #  resources :weitest

  #  resources :session

  #  resources :ads

  #  get "welcome/:id/custom" => "welcome#custom", as: :custom_material
  #end

  #namespace :api do
  #  get "welcome/index" => "welcome#index"
  #  get "welcome/game_types" => "welcome#game_types"
  #  get "welcome/banners" => "welcome#banners", :as => :banners
  #  resources :feedbacks

  #  get "welcome/document" => "welcome#document"

  #end

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
