class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("no_user", id: params[:id])
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "success_sign_up"
      login @user
      redirect_to @user
    else
      flash[:danger] = t "error_sign_up"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end
end
