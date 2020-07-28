class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate(params[:session][:password]).present?
      if @user.activated?
        log_in @user
        flash[:success] = t "login_success"
        if params[:session][:remember_me] == Settings.checkbox
          remember @user
        else
          forget @user
        end
        redirect_back_or @user
      else
        flash[:warning] = t "message_login"
        redirect_to root_url
      end
    else
      flash[:danger] = t "error_log_in"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
