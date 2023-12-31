require "rails_helper"

RSpec.describe "Confirmations", type: :request do
  let!(:user) { create(:user) }

  before { log_in(user) }

  describe "GET /new" do
    it "renders a successful responce" do
      get new_confirmation_path
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    context "with valid confirmation token" do
      let(:token) { user.generate_confirmation_token }

      it "confirms user" do
        get edit_confirmation_path(confirmation_token: token)

        user.reload
        expect(user.confirmed_at).to be_truthy
      end

      it "redirects to root path with notice" do
        get edit_confirmation_path(confirmation_token: token)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:notice]).to eq("Your email has been confirmed.")
      end
    end

    context "with invalid confirmation token" do
      it "redirects to new path with notice" do
        get edit_confirmation_path(confirmation_token: "invalid_token")

        expect(response).to redirect_to(new_confirmation_path)
        follow_redirect!
        expect(flash[:notice]).to eq("Invalid token.")
      end

      it "redirects to new with notice if token expired" do
        token = user.generate_confirmation_token
        travel User::CONFIRMATION_TOKEN_EXPIRATION + 1.minutes

        get edit_confirmation_path(confirmation_token: token)

        expect(response).to redirect_to(new_confirmation_path)
        follow_redirect!
        expect(flash[:notice]).to eq("Invalid token.")
      end
    end
  end

  describe "POST /create" do
    it "redirects to root path with notice for unconfirmed user" do
      post confirmations_path, params: { user: { email: user.email} }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(flash[:notice]).to eq("Check your email for confirmation instructions.")
    end

    it "redirects to new confirmation path for confirmed user" do
      user.confirm!

      post confirmations_path, params: { user: { email: user.email} }

      expect(response).to redirect_to(new_confirmation_path)
    end

    it "redirects to new confirmation path for not existing user" do
      post confirmations_path, params: { user: { email: "nomatch@m.com" } }
      expect(response).to redirect_to(new_confirmation_path)
    end

    it "sends confirmation email" do
      expect {
        post confirmations_path, params: { user: { email: user.email } }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    context "with invalid email" do
      it "doesn't send confirmation email" do
        %w(nomatch@mail.com abc@).each do |email|
          expect {
            post sign_up_path, params: { user: email }
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end
      end
    end
  end
end
