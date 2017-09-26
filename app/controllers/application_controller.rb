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
    post = Post.find(params[:id])
    render 'application/show_post', locals: { post: post }
  end

  def new_post
    render 'application/new_post'
  end

  def create_post
    post = Post.new('title' => params['title'], 'author' => params['author'], 'body' => params['body'])
    post.save

    redirect_to '/list_posts'
  end

  def edit_post
    post = Post.find(params[:id])
    render 'application/edit_post', locals: { post: post }
  end

  def update_post
    update_query = <<-SQL
      UPDATE posts
      SET   title = ?,
            body = ?,
            author = ?
      WHERE id = ?
    SQL

    connection.execute update_query, params['title'], params['body'], params['author'], params['id']
    redirect_to '/list_posts'
  end

  def delete_post
    connection.execute("DELETE FROM posts WHERE id = ?", params[:id])

    redirect_to '/list_posts'
  end

  private

  def connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end

  def find_post_by_id(id)
    find_query = "SELECT * FROM posts WHERE id = ?"
    post = connection.execute(find_query, id).first
  end
end
