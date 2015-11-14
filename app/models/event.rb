class Event < ActiveRecord::Base
  belongs_to :category
  has_many :user_events
  has_many :users, through: :user_events

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :title, presence: true
  validates :category_id, presence: true
end
