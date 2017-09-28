class CommentsController < ApplicationController
  before_action :find_post, only: [:create, :destroy]

  def index
    @comments = Comment.all
    render comments_path
  end

  def create
    @comment = @post.build_comment(params[:comment])

    if @comment.save
      redirect_to post_path(@post.id)
    else
      render 'posts/show'
    end
  end

  def destroy
    @post.delete_comment(params[:id])
    redirect_to post_path(@post.id)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end