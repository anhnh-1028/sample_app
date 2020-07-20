class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :load_user_with_follow, only: :create
  before_action :load_user_with_unfollow, only: :destroy

  def create
    current_user.follow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_user_with_follow
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "error_loaded"
    redirect_to root_path
  end

  def load_user_with_unfollow
    relationship = Relationship.find_by(id: params[:id])
    return if @user = relationship.followed
    flash[:danger] = t "error_loaded"
    redirect_to current_user
  end
end
