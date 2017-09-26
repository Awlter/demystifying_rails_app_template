Rails.application.routes.draw do
  get '/hello_world'       => 'application#hello_world'
  get '/hello_world/:name' => 'application#hello_world'
  get '/list_posts'        => 'application#list_posts'
  get '/show_post/:id'     => 'application#show_post'
end
