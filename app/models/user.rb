class User < ApplicationRecord
  has_many :active_times, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :owned_bookings, class_name: "Booking", foreign_key: "owner_id", dependent: :destroy
  has_many :mail_templates, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, length: { in: 1..20 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :create_default_active_times

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.username = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
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

  def ensure_confirmation_template_exists
    mail_templates.find_or_create_by!(name: "confirmation_email") do |template|
      template.subject = "【予約確認】ご予約ありがとうございます"
      template.body = <<~TEXT
        <%= @booking.name %> 様

        ご予約ありがとうございます。
        以下の内容で承りました。

        開始: <%= @booking.start_time.strftime('%Y年%m月%d日 %H:%M') %>
        終了: <%= @booking.end_time.strftime('%Y年%m月%d日 %H:%M') %>

        ---
        このメールは自動送信されています。
      TEXT
    end
  end
end
