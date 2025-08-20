require 'rails_helper'

RSpec.describe "予約機能について", type: :system, js: true do
  let(:owner) { create(:user) }
  let!(:active_time) { create(:active_time, user: owner, timerex_enabled: true) }

  before do
    sign_in owner
    visit schedule_bookings_path(owner_id: owner)
  end

  it "リンクをクリックして入力フォームに移り名前とメールアドレスを入力して確定できる" do
    within(".schedule-week") do
      expect(page).to have_css('a.time-slot', text: "12:00~12:30", wait: 5)
      first('a.time-slot', text: "12:00~12:30").click
    end

    within("#booking_frame") do
      expect(page).to have_field("お名前", wait: 5)
      fill_in "お名前", with: "テストユーザー"
      fill_in "メールアドレス", with: "test@example.com"
      click_button "確定"
    end
  end
end
