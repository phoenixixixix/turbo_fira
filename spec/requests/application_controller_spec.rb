require "rails_helper"

RSpec.describe "ApplicationControllers", type: :request do
  describe "#current_user" do
    it "displays user email when a current user present (i.e. user logged in)" do
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
