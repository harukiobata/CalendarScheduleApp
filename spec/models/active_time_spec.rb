require 'rails_helper'

RSpec.describe ActiveTime, type: :model do
  let(:user) { create(:user) }

  describe "バリデーション" do
    it "有効なデータの時は通る" do
      active_time = build(:active_time, user: user)
      expect(active_time).to be_valid
    end

    it "開始時間が終了時間より後の場合なら無効" do
      active_time = build(:active_time, user: user, start_time: "10:00", end_time: "09:00")
      expect(active_time).to_not be_valid
      expect(active_time.errors[:start_time]).to include("開始時間は終了時間より前にしてください")
    end

    it '粒度が不正なら無効' do
      active_time = build(:active_time, user: user, granularity_minutes: 10)
      expect(active_time).to_not be_valid
    end

    it "ユーザーに属している必要がある" do
      active_time = build(:active_time, user: nil)
      expect(active_time).not_to be_valid
    end
  end
end
