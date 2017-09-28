class PostsController < ApplicationController
  def index
    posts = Post.all

    render 'application/list_posts', locals: { posts: posts }
  end

  def show
    post = Post.find(params[:id])
    comment = Comment.new

    render 'application/show_post', locals: { post: post, comment: comment }
  end

  def new
    post = Post.new

    render 'application/new_post', locals: { post: post }
  end

  def create
    post = Post.new('title' => params['title'], 'author' => params['author'], 'body' => params['body'])

    if post.save
      redirect_to '/list_posts'
    else
      render 'application/new_post', locals: { post: post }
    end
  end

  def edit
    post = Post.find(params[:id])
    render 'application/edit_post', locals: { post: post }
  end

  def update
    post = Post.find(params[:id])
    post.set_attributes('title' => params['title'], 'author' => params['author'], 'body' => params['body'])

    if post.save
      redirect_to '/list_posts'
    else
      render 'application/edit_post', locals: { post: post }
    end
  end

  def post
    post = Post.find(params[:id])
    post.destroy

    redirect_to '/list_posts'
  end
end