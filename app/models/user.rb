class User < ApplicationRecord
  has_secure_password

  belongs_to :office
  has_many :attachments

  validates :ci_number, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :full_name, presence: true, length: { minimum: 5 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :office_id, :role, presence: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  enum role: [:employee, :manager, :admin]

  default_scope { where(active: true) }
end
