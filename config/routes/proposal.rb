resources :proposals do
  resources :proposals_dashboard, as: :dashboard, path: :dashboard, only: [:index] do
    collection do
      patch :publish
      get :supports
      get :stats
    end

    member do
      post :execute
      get :new_request
      post :create_request
    end
  end

  member do
    post :vote
    post :vote_featured
    put :flag
    put :unflag
    get :retire_form
    get :share
    get :created
    patch :retire
    patch :publish
  end

  collection do
    get :map
    get :suggest
    get :summary
  end
end
