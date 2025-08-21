class User < ApplicationRecord
  has_many :active_times, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :owned_bookings, class_name: "Booking", foreign_key: "owner_id", dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { in: 1..20 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :create_default_active_times
  before_create :generate_booking_token

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.username = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest?
    email == "guest@example.com"
  end

  def zoom_connected?
    zoom_access_token.present? && zoom_token_expires_at&.future?
  end

  private

  def create_default_active_times
    (0..6).each do |dow|
      active_times.create!(
        day_of_week: dow,
        start_time: "00:00",
        end_time: "23:59",
        display_start_time: "00:00",
        display_end_time: "23:59",
        granularity_minutes: 30,
        timerex_enabled: true
      )
    end
  end

  def generate_booking_token
    self.booking_token ||= SecureRandom.urlsafe_base64(12)
  end
end
