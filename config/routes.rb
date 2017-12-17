Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :posts
      resources :users, only: :update
      post 'sign_in' => 'auth#sign_in'
      post 'sign_up' => 'auth#sign_up'
      get 'reports/by_author' => 'reports#by_author'
    end
  end
end
