require "rails_helper"

RSpec.describe "スケジュールについて", type: :system, js: true do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  it "日付を前後に変更し表示が切り替わること" do
    within "#daily_schedule" do
      today = Date.current.strftime("%Y年%-m月%-d日")
      expect(find(".schedule-nav__date")).to have_content(today)

      click_link "翌日"
      next_day = (Date.current + 1).strftime("%Y年%-m月%-d日")
      expect(find(".schedule-nav__date")).to have_content(next_day)

      click_link "前日"
      expect(find(".schedule-nav__date")).to have_content(today)
    end
  end

  it "スケジュールの活動時間内のマスをクリックするとevent/newの入力欄に日付,開始時間,終了時間が入る" do
    within "#daily_schedule" do
      expect(page).to have_selector(".schedule-grid__block--active", text: "09:00")
      first(".schedule-grid__block--active", text: "09:00").click
    end
    within "#event_panel" do
      expect(page).to have_field("event[start_time]", wait: 5)
      expect(find_field("event[start_time]").value).to start_with("09:00")
      expect(find_field("event[end_time]").value).to start_with("09:30")
      expect(find_field("event[date]").value).to eq((Date.current - 2).to_s)
    end
  end

  it "カレンダーの日付をクリックするとその日付がbase_dateになる" do
    target_date = Time.zone.today.change(day: 8)
    within("#calendar") do
      find("a[data-calendar-click-date-value='#{target_date}']").click
    end
    within("#daily_schedule") do
      expect(page).to have_content("2025年7月8日")
    end
  end
end
