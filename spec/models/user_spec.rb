require "rails_helper"

RSpec.describe User, type: :model do
  describe "email" do
    subject { build(:user) }

    it "doesn't create User without email" do
      subject.email = ""
      expect { subject.save }.to change { User.count }.by(0)
    end

    it "doesn't create User with email that already exists" do
      email = "occupied@mail.com"
      create(:user, email: email)

      subject.email = email

      expect { subject.save }.to change { User.count }.by(0)
    end

    describe "format" do
      it "expects any issues with valid formats" do
        valid_emails = %w[a@mail.com a@mail.com.ua]

        valid_emails.each do |email|
          subject.email = email
          expect(subject).to be_valid
        end
      end

      it "expects error when email prefix format is invalid" do
        invalid_prefixes = %w[abc abc@]

        invalid_prefixes.each do |email|
          subject.email = email
          subject.valid?
          expect(subject.errors.full_messages).to include("Email is invalid")
        end
      end

      it "expects error when email domain format is invalid" do
        invalid_domains = %w[a@mail..com a@mail.com- a@mail#com]

        invalid_domains.each do |email|
          subject.email = email
          subject.valid?
          expect(subject.errors.full_messages).to include("Email is invalid")
        end
      end
    end
  end

  describe "callbacks" do
    describe "#downcase_email" do
      it "expects to save user's email in downcase" do
        upcase_email = "UPCASE@MAIL.COM"
        downcase_email = upcase_email.downcase
        user = build(:user, email: upcase_email)

        user.save

        expect(user.email).to_not eq(upcase_email)
        expect(user.email).to eq(downcase_email)
      end
    end
  end
end
