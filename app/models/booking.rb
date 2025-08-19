class Booking < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :start_time, presence: true
  validates :end_time, presence: true

  private

  def overlaps_existing?
    owner.bookings.where.not(id: id)
         .where("start_time < ? AND end_time > ?", end_time, start_time)
         .exists? ||
    owner.events
         .where("start_time < ? AND end_time > ?", end_time, start_time)
         .exists?
  end
end
