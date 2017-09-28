class CommentsController < ApplicationController
  def index
    @comments = Comment.all
    render 'application/list_comments'
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = post.build_comment('body' => params['body'], 'author' => params['author'])

    if comment.save
      redirect_to "/show_post/#{params['post_id']}"
    else
      render 'application/show_post'
    end
  end

  def delete
    post = Post.find(params[:post_id])
    post.delete_comment(params[:comment_id])
    redirect_to "/show_post/#{params['post_id']}"
  end
end