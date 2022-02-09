# frozen_string_literal: true

# The User Model
class User < ApplicationRecord
  include Memberable
  rolify
  has_secure_password

  before_validation :downcase_email
  validates :email, uniqueness: true
  validates :name, :email, presence: true
  validates :password, length: { minimum: 8 }, if: :password

  belongs_to :memberable, polymorphic: true, optional: true

  private

  def downcase_email
    self.email = email.downcase if email?
  end
end
