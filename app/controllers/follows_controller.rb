class FollowsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    follow = current_user.follows.find(params[:id])
    follow.destroy
    redirect_to users_path, notice: "Unfollowed."
  end
end
