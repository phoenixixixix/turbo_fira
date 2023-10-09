require "rails_helper"

RSpec.describe "ApplicationControllers", type: :request do
  describe "#current_user" do
    it "expects current_user to be present after signing up" do
      user_attributes = { email: "current-user@mail.com", password: "welcome", password_confirmation: "welcome" }

      post sign_up_path, params: { user: user_attributes }
      follow_redirect!

      expect(response.body).to include(user_attributes[:email])
    end

    it "expects current_user to be present when user logged in" do
      user = create(:user)
      log_in(user)

      get root_path

      expect(response.body).to include(user.email)
    end
  end

  describe "#authenticate_user!" do
    it "redirect not authenticated user to log in page" do
      post stacks_path

      expect(response).to redirect_to(log_in_path)

      follow_redirect!
      expect(response.body).to include("Log In or Sign Up to continue.")
    end
  end
end
