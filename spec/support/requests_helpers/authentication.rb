module RequestsHelpers
  module Authentication
    def log_in(user, password: nil)
      attributes = { email: user.email, password: set_password(password) }

      post log_in_path, params: { user: attributes }
    end

    private

    def set_password(value = nil)
      value.nil? ? "welcome" : value
    end
  end
end
