class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello_world
    name = params[:name] || "World"
    render 'application/hello_world', locals: { name: name }
  end
end
