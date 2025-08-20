require 'rails_helper'

RSpec.describe "活動時間について", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit active_times_path
  end

  it "編集リンクをクリックするとフォームが表示される" do
    click_link "・ 日曜日 00:00 - 23:59"

    expect(page).to have_content "日曜日 の編集"
    expect(page).to have_field("開始時間")
    expect(page).to have_field("終了時間")
    expect(page).to have_field("予定予約機能の表示開始時間")
    expect(page).to have_field("予定予約機能の表示終了時間")
    expect(page).to have_field("予定予約機能を有効にする", type: "checkbox")
    expect(page).to have_field("この設定を全曜日に適用する", type: "checkbox")
  end

  it "編集リンクをクリックし正しい値を入れることで編集できる" do
    click_link "・ 日曜日 00:00 - 23:59"

    fill_in "開始時間", with: "08:00"
    fill_in "終了時間", with: "20:00"
    fill_in "予定予約機能の表示開始時間", with: "12:00"
    fill_in "予定予約機能の表示終了時間", with: "18:00"
    click_button "設定を更新する"

    expect(page).to have_content("活動時間を更新しました", wait: 5)
    expect(page).to have_link("▶︎ 日曜日 08:00 - 20:00", wait: 5)
  end

  it "開始時間が終了時間より後だとエラーになる" do
    click_link "・ 日曜日 00:00 - 23:59"

    fill_in "開始時間", with: "22:00"
    fill_in "終了時間", with: "08:00"
    click_button "設定を更新する"

    expect(page).to have_content "終了時間は開始時間より後にしてください"
    expect(page).to have_content "更新に失敗しました"
  end

  it "一括更新で全曜日のスケジュール表示間隔を変えられる" do
    select "15", from: "表示間隔（分）"
    click_button "一括変更"

    expect(page).to have_content "スケジュールの表示間隔（15分）を全曜日に適用しました"
  end

  it "既存イベントを含むような活動時間でなければエラーになる" do
    create(:event, user: user, date: Date.parse("2025-07-08"), start_time: "2025-07-08 12:00", end_time: "2025-07-08 14:00")
    click_link "・ 火曜日 00:00 - 23:59"

    fill_in "開始時間", with: "13:00"
    fill_in "終了時間", with: "14:00"
    click_button "設定を更新する"

    expect(page).to have_content "開始時間又は終了時間は既存のイベントの時間を含むように設定してください"
    expect(page).to have_content "更新に失敗しました"
  end

  it "予約開始時間が開始時間より前だとエラーになる" do
    click_link "・ 日曜日 00:00 - 23:59"

    fill_in "開始時間", with: "13:00"
    fill_in "予定予約機能の表示開始時間", with: "12:00"
    fill_in "予定予約機能の表示終了時間", with: "18:00"
    click_button "設定を更新する"

    expect(page).to have_content "予約開始時間は開始時間より後に設定してください"
    expect(page).to have_content "更新に失敗しました"
  end

  it "予約終了時間が終了時間より後だとエラーになる" do
    click_link "・ 日曜日 00:00 - 23:59"

    fill_in "終了時間", with: "17:00"
    fill_in "予定予約機能の表示開始時間", with: "12:00"
    fill_in "予定予約機能の表示終了時間", with: "18:00"
    click_button "設定を更新する"

    expect(page).to have_content "予約終了時間は終了時間より前に設定してください"
    expect(page).to have_content "更新に失敗しました"
  end

  it "編集リンクをクリックして予約時間に正しい値を入れることで編集できる" do
    click_link "・ 日曜日 00:00 - 23:59"

    fill_in "予定予約機能の表示開始時間", with: "12:00"
    fill_in "予定予約機能の表示終了時間", with: "18:00"
    click_button "設定を更新する"
    expect(page).to have_content "活動時間を更新しました"
  end
end
