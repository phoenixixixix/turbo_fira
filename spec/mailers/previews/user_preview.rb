# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user/confirmation
  def confirmation
    user = User.create!(email: "user_mailer_preview#{rand(1000)}@mail.com",
                         password: "user_mailer_preview",
                         password_confirmation: "user_mailer_preview")
    confirmation_token = user.generate_confirmation_token

    UserMailer.confirmation(user, confirmation_token)
  end
end
