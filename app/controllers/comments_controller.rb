class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to post_path(@post), notice: "Comment added!"
    else
      redirect_to post_path(@post), alert: "Comment could not be saved."
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@comment.post), notice: "Comment deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
