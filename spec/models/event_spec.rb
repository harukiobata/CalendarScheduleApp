require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:user) { create(:user) }

  before do
    user.active_times.find_by(day_of_week: 4).update!(
    start_time: Time.zone.parse("08:00"),
    end_time: Time.zone.parse("20:00")
  )
  end

  it "活動時間内かつ有効なデータは通る" do
    event = build(:event, user: user)
    expect(event).to be_valid
  end

  it "タイトルがなければ無効" do
    event = build(:event, user: user, title: nil)
    expect(event).to_not  be_valid
  end

  it "開始時間が終了時間よりも後の場合は無効" do
    event = build(:event, user: user, start_time: "11:00", end_time: "10:00")
    expect(event).to_not be_valid
  end

  it "活動時間外の予定は無効になる" do
    event = build(:event, user: user, start_time: "7:00", end_time: "7:45")
    date = event.date
    event.start_time = Time.zone.parse("#{date} #{event.start_time}")
    event.end_time   = Time.zone.parse("#{date} #{event.end_time}")
    expect(event).to_not be_valid
  end

  it "重複した時間の予定がある場合は無効" do
    existing_event = create(:event, user: user)
    new_event = build(:event, user: user)
    expect(new_event).to_not be_valid
  end
end
