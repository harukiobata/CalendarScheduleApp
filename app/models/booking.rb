class Booking < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate  :end_after_start

  private

  def end_after_start
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "は開始時間より後に設定してください")
    end
  end

  def overlaps_existing?
    owner.bookings.where.not(id: id)
         .where("start_time < ? AND end_time > ?", end_time, start_time)
         .exists? ||
    owner.events
         .where("start_time < ? AND end_time > ?", end_time, start_time)
         .exists?
  end
end
