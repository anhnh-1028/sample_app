class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(update edit)
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.page(params[:page]).per Settings.pagination
  end

  def new
    @user = User.new
  end

  def show
    return if @user

    flash[:warning] = t("no_user", id: params[:id])
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user_mailer.account_activation.flash_activate"
      redirect_to root_path
    else
      flash[:danger] = t "error_sign_up"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash[:warning] = t "error_updated"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
      redirect_to users_url
    else
      flash[:danger] = t "user_deleted"
      redirect_to root_path
    end
  end
  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "error_loaded"
  end

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in."
    redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end
end
