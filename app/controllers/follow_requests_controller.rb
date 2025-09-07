class FollowRequestsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Only show pending requests
    @follow_requests = current_user.received_follow_requests.where(status: "pending")
  end

  def create
    @user = User.find(params[:user_id])

    if current_user.sent_follow_requests.exists?(receiver: @user)
      redirect_to users_path, alert: "Follow request already sent."
    else
      current_user.sent_follow_requests.create(receiver: @user, status: "pending")
      redirect_to users_path, notice: "Follow request sent!"
    end
  end

  def accept
    request = current_user.received_follow_requests.find(params[:id])
    request.update(status: "accepted")

    Follow.create!(follower: request.sender, followed: current_user)

    redirect_to follow_requests_path, notice: "Follow request accepted!"
  end

  def decline
    request = current_user.received_follow_requests.find(params[:id])
    request.update(status: "declined")
    redirect_to follow_requests_path, notice: "Follow request declined."
  end

  def destroy
    request = current_user.sent_follow_requests.find(params[:id])
    request.destroy
    redirect_to users_path, notice: "Follow request cancelled."
  end
end
