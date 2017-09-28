class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new('title' => params['title'], 'author' => params['author'], 'body' => params['body'])

    if post.save
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @post.set_attributes('title' => params['title'], 'author' => params['author'], 'body' => params['body'])

    if post.save
      redirect_to post_path(@post)
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy

    redirect_to posts_path
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end
end