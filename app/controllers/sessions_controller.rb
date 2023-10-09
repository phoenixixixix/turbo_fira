class SessionsController < ApplicationController
  before_action :redirect_if_authenticated!, except: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticate(params[:user][:password])
      login(@user)

      redirect_to root_path, notice: "Logged in successfully!"
    else
      @user = User.new(email: params[:user][:email], password: params[:user][:password])
      @user.errors.add(:base, message: "Invalid email or password.")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out successfully."
  end
end
