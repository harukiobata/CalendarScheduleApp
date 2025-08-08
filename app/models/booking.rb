class Booking < ApplicationRecord
  belongs_to :user
  validates :name, :email, :start_time, :end_time, presence: true
end
