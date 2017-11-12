Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :posts
      post 'sign_in' => 'users#sign_in'
      post 'sign_up' => 'users#sign_up'
      get 'test_token' => 'test#test_token'
      get 'reports/by_author' => 'reports#by_author'
    end
  end
end
