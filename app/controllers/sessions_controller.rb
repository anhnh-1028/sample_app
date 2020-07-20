class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate(params[:session][:password]).present?
      flash[:success] = t "login_success"
      login @user
      params[:session][:remember_me] ==
        Settings.checkbox ? remember(@user) : forget(@user)
      redirect_back_or @user
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
