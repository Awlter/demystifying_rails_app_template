class CommentsController < ApplicationController
  before_action :find_post, only: [:create, :destroy]

  def index
    @comments = Comment.all
    render comments_path
  end

  def create
    @comment = @post.comments.build(params[:comment])
    if @comment.save
      flash['success'] = "You have successfully created the comment."
      redirect_to post_path(@post)
    else
      flash.now['error'] = "Comment couldn't be created. Please check the errors."
      render 'posts/show'
    end
  end

  def destroy
    @post.comments.delete(params[:id])
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end