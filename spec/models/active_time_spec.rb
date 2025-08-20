require 'rails_helper'

RSpec.describe ActiveTime, type: :model do
  let(:user) { create(:user) }
  let(:active_time) do
    FactoryBot.create(:active_time,
      user: user,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("18:00"),
      display_start_time: Time.zone.parse("12:00"),
      display_end_time: Time.zone.parse("16:00"),
      timerex_enabled: true,
      granularity_minutes: 30
    )
  end
  let!(:event) { create(:event, user: user, start_time: Time.zone.parse("2025-07-10 12:00"), end_time: Time.zone.parse("2025-07-10 13:30")) }

  describe "バリデーション" do
    it "有効なデータの時は通る" do
      active_time = build(:active_time, user: user)
      expect(active_time).to be_valid
    end

    it "開始時間がnuilだと無効" do
      active_time = build(:active_time, start_time: nil)
      expect(active_time).to_not be_valid
    end

    it "終了時間がnilだと無効" do
      active_time = build(:active_time, end_time: nil)
      expect(active_time).to_not be_valid
    end

    it "終了時間が開始時間より前なら無効" do
      active_time = build(:active_time, user: user, start_time: "10:00", end_time: "09:00")
      expect(active_time).to_not be_valid
      expect(active_time.errors[:end_time]).to include("は開始時間より後にしてください")
    end

    it '粒度が不正なら無効' do
      active_time = build(:active_time, user: user, granularity_minutes: 10)
      expect(active_time).to_not be_valid
    end

    it "既にある予定を覆う形の変更は通る" do
      active_time = build(:active_time, user: user,
      day_of_week: 4,
      start_time: Time.zone.parse("11:00"),
      end_time:   Time.zone.parse("14:00"),
      display_start_time: Time.zone.parse("11:00"),
      display_end_time:   Time.zone.parse("14:00"))
      expect(active_time).to be_valid
    end

    it "既にある予定を覆わない形の変更は通らない" do
      active_time = build(:active_time, user: user,
      day_of_week: 4,
      start_time: Time.zone.parse("13:00"),
      end_time:   Time.zone.parse("14:00"))
      expect(active_time).to_not be_valid
      expect(active_time.errors[:start_time]).to include("又は終了時間は既存のイベントの時間を含むように設定してください")
    end

    it "予定開始時間が開始時間より前なら無効" do
      active_time = build(:active_time,
        user: user,
        start_time: Time.zone.parse("09:00"),
        end_time:   Time.zone.parse("18:00"),
        display_start_time: Time.zone.parse("08:00"),
        display_end_time:   Time.zone.parse("12:00")
      )
      expect(active_time).to_not be_valid
      expect(active_time.errors[:display_start_time]).to include("は開始時間より後に設定してください")
    end
  
    it "予定終了時間が終了時間より後なら無効" do
      active_time = build(:active_time,
        user: user,
        start_time: Time.zone.parse("09:00"),
        end_time:   Time.zone.parse("18:00"),
        display_start_time: Time.zone.parse("10:00"),
        display_end_time:   Time.zone.parse("20:00")
      )
      expect(active_time).to_not be_valid
      expect(active_time.errors[:display_end_time]).to include("は終了時間より前に設定してください")
    end
  
    it "予定開始時間と予定終了時間が有効範囲なら通る" do
      active_time = build(:active_time,
        user: user,
        start_time: Time.zone.parse("09:00"),
        end_time:   Time.zone.parse("18:00"),
        display_start_time: Time.zone.parse("10:00"),
        display_end_time:   Time.zone.parse("17:00")
      )
      expect(active_time).to be_valid
    end
  end
  describe "メソットについて" do
    it "時間を分に変換できること" do
      time = Time.zone.parse("13:30")
      expect(active_time.minutes_since_midnight(time)).to eq(810) # 13*60+30=810
    end

    it "配列で返して開始終了がペアであること" do
      blocks = active_time.time_blocks
      expect(blocks).to be_an(Array)
      expect(blocks.first.length).to eq(2)
    end

    it "粒度に応じて正しい数の時間ブロックを返すこと" do
      expected_count = (24 * 60) / active_time.granularity_minutes
      expect(active_time.time_blocks.size).to eq(expected_count)
    end

    it "時間帯がアクティブ時間内ならtrueを返すこと" do
      expect(active_time.within_time_range?(Time.zone.parse("09:00"), Time.zone.parse("09:30"))).to be true
    end

    it "時間帯がアクティブ時間外ならfalseを返すこと" do
      expect(active_time.within_time_range?(Time.zone.parse("08:00"), Time.zone.parse("08:30"))).to be false
    end
  end
end
