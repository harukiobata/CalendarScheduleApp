require 'rails_helper'

RSpec.describe "活動時間について", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit active_times_path
  end

  it "編集リンクをクリックするとフォームが表示される" do
    click_link "・ 日曜日 00:00 - 23:59 （30分）"

    expect(page).to have_content "日曜日 の編集"
    expect(page).to have_field("開始時間")
    expect(page).to have_field("終了時間")
    expect(page).to have_select("表示時間の間隔(分)")
  end

  it "編集リンクをクリックし正しい値を入れることで編集できる" do
    click_link "・ 日曜日 00:00 - 23:59 （30分）"

    select "15", from: "表示時間の間隔(分)"
    fill_in "開始時間", with: "08:00"
    fill_in "終了時間", with: "20:00"
    click_button "設定を更新する"
    expect(page).to have_content "活動時間を更新しました"
    expect(page).to have_link "▶︎ 日曜日 08:00 - 20:00 （15分）"
  end

  it "開始時間が終了時間より後だとエラーになる" do
    click_link "・ 日曜日 00:00 - 23:59 （30分）"

    select "15", from: "表示時間の間隔(分)"
    fill_in "開始時間", with: "22:00"
    fill_in "終了時間", with: "08:00"
    click_button "設定を更新する"

    expect(page).to have_content "開始時間は終了時間より前にしてください"
    expect(page).to have_content "更新に失敗しました"
  end
end
