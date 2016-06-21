Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'questions#index'

  get '/verification/:token', to: "users#verification", as: :account_activation
  get '/password_resets/:token', to: "password_resets#new", as: :reset_password
  resources :password_requests, only: [:create, :new]
  resources :password_resets, only: [:create]

  resources :users, only: [:new, :create, :show, :edit, :update] do
    member do
      post 'follow'
      post 'unfollow'
    end
  end


  scope :my_account do
    resources :credit_transactions, only: [:index]
    get '/questions', to: "users#myquestions", as: :myquestions
  end

  resources :questions do
    collection do
      post 'new_question_loader'
    #FIXME_AB:  collection in questions controller; done
      get 'following_people_questions'
    end
    member do
      get 'publish', to: "questions#publish", as: :publish
      get 'unpublish', to: "questions#unpublish", as: :unpublish
    end
    resources :answers do
      member do
        get 'upvote', to: "answers#upvote", as: :upvote
        get 'downvote', to: "answers#downvote", as: :downvote
      end
    end
  end

  resources :abuse_reports

  resources :comments, only: [:new, :create] do
    member do
      get 'upvote'
      get 'downvote'
    end
  end

  resources :credits, only: [:new, :create] do
    resources :charges, only: [:new, :create]
  end


  resources :topics, only: [] do
    member do
      get 'questions'
    end
  end

  resources :user_notifications, only: [] do
    collection do
      post 'mark_read'
    end
  end

  controller :search do
    get 'search', action: :create
  end

  controller :session do
    get  'login', action: :new
    post 'login', action: :create
    delete 'logout',action: :destroy
  end

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
