class ActiveTime < ApplicationRecord
  belongs_to :user

  validates :start_time, :end_time, presence: true
  validates :granularity_minutes, inclusion: { in: [ 15, 30, 45, 60 ] }
  validate :start_time_before_end_time

  private

  def start_time_before_end_time
    return if start_time.blank? || end_time.blank?

    if start_time > end_time
      errors.add(:start_time, "開始時間は終了時間より前にしてください")
    end
  end
end
