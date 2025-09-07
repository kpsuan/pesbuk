class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Show current_user posts + followed users' posts
    following_ids = current_user.following.pluck(:id)
    @posts = Post.where(user_id: [current_user.id] + following_ids)
                 .order(created_at: :desc)
                 .includes(:user, :comments, :likes)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "Post updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "Post deleted."
  end

  private

  def post_params
    params.require(:post).permit(:content, images: [])
  end
end
