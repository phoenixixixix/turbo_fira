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

    it "returns 'Not Logged In' when no user is logged in" do
      get root_path
      expect(response.body).to include("Sign Up")
    end
  end
end
