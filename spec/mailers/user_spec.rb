require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#confirmation" do
    let(:user) { create(:user) }
    let(:confirmation_token) { user.generate_confirmation_token }
    let(:mail) { UserMailer.confirmation(user, confirmation_token) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirmation Instructions")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([User::MAILER_FROM_EMAIL])
    end

    it "renders confirmation link" do
      expect(mail.body.encoded).to match(edit_confirmation_url(confirmation_token: confirmation_token))
    end
  end
end
