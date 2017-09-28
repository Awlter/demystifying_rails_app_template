Rails.application.routes.draw do
  get  '/hello_world/:name' => 'application#hello_world'

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  resources :comments, only: [:index]
end
