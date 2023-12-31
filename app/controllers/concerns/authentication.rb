module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :current_user
    helper_method :current_user
  end

  def login(user)
    reset_session
    session[:user_id] = user.id
  end

  def logout
    reset_session
  end

  def redirect_if_authenticated!
    redirect_to root_path, notice: "You are already logged in." if current_user
  end

  def authenticate_user!
    redirect_to log_in_path, notice: "Log In or Sign Up to continue." unless current_user
  end

  private

  def current_user
    @_current_user ||= session[:user_id] && User.find(session[:user_id])
  end
end
