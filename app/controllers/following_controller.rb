class FollowingController < ApplicationController
  before_action :logged_in_user, :load_user

  def index
    @title = t "relationships.following"
    @users = @user.following.page(params[:page]).per Settings.pagination
    render "users/show_follow"
  end
end
