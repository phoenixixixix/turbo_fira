class User < ApplicationRecord
  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  before_save :downcase_email

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
