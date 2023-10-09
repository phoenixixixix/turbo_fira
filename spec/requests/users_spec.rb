require "rails_helper"

RSpec.describe "/users", type: :request do
  let(:invalid_attributes) { { email: "abc", password: "", password_confirmation: "nomatch" } }

  describe "GET /sign_up" do
    it "renders a successful responce" do
      get sign_up_path
      expect(response).to be_successful
    end

    it "redirects to root path if user already logged in" do
      log_in(create(:user))

      get sign_up_path

      expect(response).to redirect_to(root_path)

      follow_redirect!
      expect(response.body).to include("You are already logged in.")
    end
  end

  describe "POST /sign_up" do
    context "with valid parameters" do
      let(:valid_attributes) { { email: "post_create@mail.com", password: "welcome", password_confirmation: "welcome" } }

      it "creates a new User" do
        expect {
          post sign_up_path, params: { user: valid_attributes }
        }.to change { User.count }.by(1)
      end

      it "redirects to root path" do
        post sign_up_path, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "doesn't create a new User" do
        expect {
          post sign_up_path, params: { user: invalid_attributes }
        }.to change { User.count }.by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post sign_up_path, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
