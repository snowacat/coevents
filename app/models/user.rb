class User < ActiveRecord::Base
  GENDER = [DEFAULT = nil, MALE = 1, FEMALE = 2]

  has_many :user_events
  has_many :events, through: :user_events

  validates :user_name, length: { maximum: 64 }, presence: true
  validates :email, length: { maximum: 128 }, presence: true, email_format: { message: "Doesn't look like an email address." }, uniqueness: true
  validates :phone_number, length: { maximum: 20 }
  validates :nationality, length: { maximum: 32 }
  validates :gender, inclusion: { in: GENDER }
end