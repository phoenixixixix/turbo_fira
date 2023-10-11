require "rails_helper"

RSpec.describe User, type: :model do
  describe "password" do
    subject { build(:user) }

    it "expects success with walid password attrs" do
      subject.assign_attributes(password_digest: "welcome", password_confirmation: "welcome")

      expect(subject).to be_valid
      expect { subject.save }.to change { User.count }.by(1)
    end

    it "requires password" do
      subject.password_digest = ""

      expect(subject).to be_invalid
      expect(subject.errors.full_messages).to include("Password can't be blank")
    end

    it "expects record invalid if password and password_confirmation don't match" do
      subject.assign_attributes(password_digest: "welcome", password_confirmation: "nomatch")

      expect(subject).to be_invalid
      expect(subject.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
  end

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

  describe "authentication mechanism" do
    let(:auth_password) { { password: "welcome" } }
    let(:authable_user) { create(:user, password: auth_password, password_confirmation: auth_password) }

    it "authenticate user" do
      expect(authable_user.authenticate(auth_password)).to be_truthy
    end

    it "doesn't authenticate user with invalid password" do
      expect(authable_user.authenticate("invalid")).to be_falsey
    end
  end

  describe "confirmation mechanism" do
    let(:user) { create(:user, confirmed_at: nil) }

    it "expects new user to be unconfirmed" do
      expect(user.confirmed_at).to be_nil
    end

    describe "#confirm!" do
      it "updates confirmed_at column" do
        user.confirm!
        expect(user.confirmed_at).to_not be_nil
      end
    end

    describe "#confirm?" do
      it "validates confirmation" do
        user.confirm!
        expect(user.confirmed?).to be_truthy

        user.confirmed_at = nil
        expect(user.confirmed?).to be_falsey
      end
    end

    describe "#generate_confirmation_token" do
      it "assigns token by which user can be retrieved from DB" do
        token = user.generate_confirmation_token

        expect(User.find_signed(token, purpose: :confirm_email)).to eq(user)
      end
    end

    describe "#send_confirmation_email!" do
      it "sends confirmation email" do
        expect {
          user.send_confirmation_email!
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
