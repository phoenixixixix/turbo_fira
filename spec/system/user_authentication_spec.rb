require "rails_helper"

describe "user authentication", type: :system do
  describe "log in" do
    context "successful" do
      let(:password) { "welcome" }
      let(:user) { create(:user, email: "user_authentication@spec.com", password: password, password_confirmation: password) }

      it "displays stacks with notice and user email" do
        visit log_in_path

        fill_in "Email", with: user.email
        fill_in "Password", with: password
        click_button "Log In"

        expect(page).to have_content("Stacks")
        expect(page).to have_content("Logged in successfully!")
        expect(page).to have_content(user.email)
      end
    end

    context "with invalid credentials" do
      it "displays an error" do
        visit log_in_path

        fill_in "Email", with: "nomatch"
        fill_in "Password", with: "nomatch"
        click_button "Log In"

        expect(page).to have_content("Invalid email or password.")
      end
    end

    context "when user already authenticated" do
      it "redirects with notice" do
        log_in(create(:user))

        visit log_in_path

        expect(page).to have_content("You are already logged in.")
      end
    end
  end

  describe "log out" do
    it "displays success notices" do
      log_in(create(:user))

      visit root_path
      click_button "Log Out"

      expect(page).to have_content("Logged out successfully.")
    end
  end

  describe "sign up" do
    context "successful" do
      it "displays stacks with notice and user email" do
        user_attributes = { email: "auth_sign_up@spec.com", password: "welcome" }
        
        visit sign_up_path

        fill_in "Email", with: user_attributes[:email]
        fill_in "Password", with: user_attributes[:password]
        fill_in "Password confirmation", with: user_attributes[:password]
        click_button "Sign Up"

        expect(page).to have_content("Stacks")
        expect(page).to have_content("Successfully registered!")
        expect(page).to have_content(user_attributes[:email])
      end
    end
  end
end
