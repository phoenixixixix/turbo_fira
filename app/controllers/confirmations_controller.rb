class ConfirmationsController < ApplicationController
  def new
    @user = User.new
  end

  def edit
    @user = User.find_signed(params[:confirmation_token], purpose: :confirm_email)

    if @user.present?
      @user.confirm!
      redirect_to root_path, notice: "Your email has been confirmed."
    else
      redirect_to new_confirmation_path, notice: "Invalid token."
    end
  end

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && !@user.confirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Check your email for confirmation instructions."
    else
      redirect_to new_confirmation_path, notice: "We could not find a user with that email or that email has already been confirmed."
    end
  end
end
