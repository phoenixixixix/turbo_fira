require "rails_helper"

RSpec.describe "/sessions", type: :request do
  let(:invalid_user_parameters) { { email: "abc", password: "nomatch" } }

  describe "GET /log_in" do
    it "renders a successful response" do
      get log_in_path
      expect(response).to be_successful
    end
  end

  describe "POST /log_in" do
    let!(:existing_user_parameters) { { email: "abc@mail.com", password: "welcome" } }
    let!(:existing_user) { create(:user, existing_user_parameters.merge(password_confirmation: existing_user_parameters[:password])) }

    it "authenticates user (i.e. adding user id in session)" do
      post log_in_path, params: { user: existing_user_parameters }
      expect(session).to have_key(:user_id)
    end

    it "redirects to root path" do
      post log_in_path, params: { user: existing_user_parameters }
      expect(response).to redirect_to(root_path)
    end

    context "with invalid user params" do
      it "does not authenticate user (i.e. does not add user id to session)" do
        post log_in_path, params: { user: invalid_user_parameters }
        expect(session).to_not have_key(:user_id)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post log_in_path, params: { user: invalid_user_parameters }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
