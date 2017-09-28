class ApplicationController < ActionController::Base
  def hello_world
    name = params[:name] || "World"
    render 'application/hello_world', locals: { name: name }
  end
end
