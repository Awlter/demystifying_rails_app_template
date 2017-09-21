Rails.application.routes.draw do
  get '/hello_world' => 'application#hello_world'
  get '/hello_world/:name' => 'application#hello_world'
end
