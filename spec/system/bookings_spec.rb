require 'rails_helper'

RSpec.describe "予約機能について", type: :system, js: true do
  let(:owner) { create(:user) }
  let!(:active_time) { create(:active_time, user: owner, timerex_enabled: true) }

  before do
    sign_in owner
    visit active_times_path
    click_link "・ 火曜日 00:00 - 23:59"
    fill_in "開始時間", with: "08:00"
    fill_in "終了時間", with: "20:00"
    fill_in "予定予約機能の表示開始時間", with: "10:00"
    fill_in "予定予約機能の表示終了時間", with: "15:30"
    check "予定予約機能を有効にする"
    check "この設定を全曜日に適用する"
    click_button "設定を更新する"
    visit schedule_bookings_path(owner_id: owner)
  end

  it "リンクをクリックして入力フォームに移り名前とメールアドレスを入力して確定できる" do
    within(".schedule-week") do
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
