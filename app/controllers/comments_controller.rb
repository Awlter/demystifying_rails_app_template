class CommentsController < ApplicationController
  before_action :find_post, only: [:create, :destroy]

  def index
    @comments = Comment.all
    render comments_path
  end

  def create
    @comment = post.build_comment('body' => params[:body], 'author' => params[:author])

    if comment.save
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def destroy
    @post.delete_comment(params[:comment_id])
    redirect_to post_path(@post)
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end
end