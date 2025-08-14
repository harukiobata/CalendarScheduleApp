class MailTemplate < ApplicationRecord
  belongs_to :user
  validates :name, :subject, :body, presence: true
end
