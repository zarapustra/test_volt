Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :posts
      post 'authenticate' => 'auth#log_in'
      get 'test_token' => 'auth#test_token'
      get 'reports/by_author' => 'reports#by_author'
    end
  end
end
