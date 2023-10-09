module Authentication
  extend ActiveSupport::Concern

  included do
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

  private

  def current_user
    @_current_user ||= session[:user_id] && User.find(session[:user_id])
  end
end
