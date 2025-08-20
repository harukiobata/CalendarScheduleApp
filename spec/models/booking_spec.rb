require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'バリデーション' do
    it '名前が必須であること' do
      booking = Booking.new(name: nil, email: 'test@example.com')
      expect(booking).not_to be_valid
      expect(booking.errors[:name]).to include("を入力してください")
    end

    it 'メールアドレスが必須であること' do
      booking = Booking.new(name: '太郎', email: nil)
      expect(booking).not_to be_valid
      expect(booking.errors[:email]).to include("を入力してください")
    end

    it 'メールアドレス形式が正しいこと' do
      booking = Booking.new(name: '太郎', email: 'invalid_email')
      expect(booking).not_to be_valid
      expect(booking.errors[:email]).to include("は不正な値です")
    end
  end
end
