class ApplicationController < ActionController::Base
  def hello_world
    name = params[:name] || "World"
    render 'application/hello_world', locals: { name: name }
  end

  def list_posts
    posts = connection.execute("SELECT * FROM posts")

    render 'application/list_posts', locals: { posts: posts }
  end

  def show_post
    id = params[:id]

    post = connection.execute("SELECT * FROM posts WHERE id = ?", id)

    render 'application/show_post', locals: {post: post.first}
  end

  def new_post
    render 'application/new_post'
  end

  def create_post
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, create_at) VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
      params['title'],
      params['body'],
      params['author'],
      Date.current.to_s

    redirect_to '/list_posts'
  end

  private

  def connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end
end
