module SystemHelpers
  module Authentication
    def log_in(user, password: nil)
      user_fixture_password = "welcome"
      password = password.nil? ? user_fixture_password : password

      visit "/log_in"

      fill_in "Email", with: user.email
      fill_in "Password", with: password
      click_button "Log In"
    end
  end
end
