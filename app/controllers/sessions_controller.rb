class SessionsController < ApplicationController
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
end
