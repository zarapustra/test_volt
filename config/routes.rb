Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :posts
      resources :users, except: [:index, :create, :destroy]
      post 'sign_in' => 'auth#sign_in'
      post 'sign_up' => 'users#sign_up'
      get 'reports/by_author' => 'reports#by_author'
      get 'current_user' => 'users#show'
    end
  end
end
