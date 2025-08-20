require 'rails_helper'

RSpec.describe "System/event", type: :system, js: true do
  # 注意事項
  # turbo FrameとHotwireの関係でcreate,updateに関してはテストコードが異なります。
  # createについて　execute_scriptでdateを入力,あとはfill_in。(fill_inでdateをセットすると正しい値が入らず崩れるため)
  # updateについて　一度date_strに移してからかつfindで待つ操作が必要。(それがないとdateに正しい値が入らずテストにならないため)他のstart_time,end_timeもfind setで（安定するため)
  # update(titleなどdate,datetime型以外) fill_inで問題なし
  # 以上から操作が混在しておりますがturboframe下でのテストを成立させるための工夫です。

  let(:user) { create(:user) }
  let!(:event) { create(:event, user: user, title: "重複用テスト") }
  let(:target_date) { Date.parse("2025-07-10") }
  let(:tuesday_date) { Date.parse("2025-07-08") }

  before do
    sign_in user
    visit root_path
  end

  describe "activetimeに関わらないcreate,update,index,destroyについて" do
    it "新規予定を作成できる" do
      within("turbo-frame#event_panel") do
        page.execute_script("document.getElementById('event-date').value = '#{Date.current.strftime('%Y-%m-%d')}'")
        fill_in "event-title", with: "会議"
        fill_in "event-start_time", with: "10:00"
        fill_in "event-end_time", with: "11:00"
        click_button "作成"
      end
      expect(page).to have_content("新規予定を追加しました")
    end

    it "終了時間が開始時間より早いと失敗する" do
      within("turbo-frame#event_panel") do
        page.execute_script("document.getElementById('event-date').value = '#{Date.current.strftime('%Y-%m-%d')}'")
        fill_in "event-title", with: "end_error_test"
        fill_in "event-start_time", with: "12:00"
        fill_in "event-end_time", with: "11:00"
        click_button "作成"
      end
      expect(page).to have_content("終了時間は開始時間より後である必要があります")
      expect(page).to have_content("予定の追加に失敗しました")
    end

    it "予定が重複する場合エラーになる" do
      within("turbo-frame#event_panel") do
        page.execute_script("document.getElementById('event-date').value = '#{target_date.strftime('%Y-%m-%d')}'")
        fill_in "event-title", with: "cascade_test"
        fill_in "event-start_time", with: "08:00"
        fill_in "event-end_time", with: "09:30"
        click_button "作成"
      end
      expect(page).to have_content("予定が重なっています: 重複用テスト")
      expect(page).to have_content("予定の追加に失敗しました")
    end

    it "予定が表示される" do
      within("section.event-section") do
        click_link "一覧"
      end
      within("turbo-frame#event_panel") do
        expect(page).to have_content event.title
      end
    end

    it "予定を削除できる" do
      within("section.event-section") do
        click_link "一覧"
      end
      within("turbo-frame#event_panel") do
        find("button.event-actions__toggle").click
        expect(page).to have_link("削除")
        accept_confirm do
          click_link "削除"
        end
      end
      expect(page).not_to have_content event.title
    end

    it "予定を編集できる" do
      within("section.event-section") do
        click_link "一覧"
      end
      within("turbo-frame#event_panel") do
        find("button.event-actions__toggle").click
        click_link "編集"
      end
      fill_in "event-title", with: "編集された予定"
      click_button "更新"

      within("turbo-frame#event_panel") do
        expect(page).to have_content "編集された予定"
      end
    end

    it "予定編集時に重複したときエラーになる" do
      within("turbo-frame#event_panel") do
        page.execute_script("document.getElementById('event-date').value = '#{tuesday_date.strftime('%Y-%m-%d')}'")
        fill_in "event-title", with: "重複するための予定"
        fill_in "event-start_time", with: "10:00"
        fill_in "event-end_time", with: "11:00"
        click_button "作成"
      end
      within("section.event-section") do
        find('a', text: '一覧').click
      end
      within("turbo-frame#event_panel") do
        row = find("tr", text: "重複するための予定")
        within(row) do
          find("button.event-actions__toggle").click
          click_link "編集"
        end
      end
      date_str = target_date.strftime('%Y-%m-%d')
      within("turbo-frame#event_panel") do
        find("#event-date")
        page.execute_script("document.getElementById('event-date').value = '#{date_str}'")
        find("#event-start_time").set("08:00")
        find("#event-end_time").set("09:30")
        click_button "更新"
      end
      expect(page).to have_content("予定が重なっています: 重複用テスト")
      expect(page).to have_content("予定の更新に失敗しました")
    end
  end
  describe "activetimeに依存するcreate,updateについて" do
    before do
      visit active_times_path
      click_link "・ 火曜日 00:00 - 23:59"
      fill_in "開始時間", with: "08:00"
      fill_in "終了時間", with: "20:00"
      fill_in "予定予約機能の表示開始時間", with: "10:00"
      fill_in "予定予約機能の表示終了時間", with: "10:30"
      click_button "設定を更新する"
      visit root_path
    end

    it "活動時間外にイベントを入れようとするとエラーになる" do
      within("turbo-frame#event_panel") do
        page.execute_script("document.getElementById('event-date').value = '#{tuesday_date.strftime('%Y-%m-%d')}'")
        fill_in "event-title", with: "end_error_test"
        fill_in "event-start_time", with: "21:00"
        fill_in "event-end_time", with: "22:00"
        click_button "作成"
      end
      expect(page).to have_content("開始時間は活動時間内でなければなりません")
      expect(page).to have_content("予定の追加に失敗しました")
    end

    it "活動時間外にイベントを変更しようとするとエラーになる" do
      within("section.event-section") do
        click_link "一覧"
      end
      within("turbo-frame#event_panel") do
        find("button.event-actions__toggle").click
        click_link "編集"
      end
      date_str = tuesday_date.strftime('%Y-%m-%d')
      within("turbo-frame#event_panel") do
        find("#event-date")
        page.execute_script("document.getElementById('event-date').value = '#{date_str}'")
        find("#event-start_time").set("07:00")
        find("#event-end_time").set("08:00")
        click_button "更新"
      end
      expect(page).to have_content("開始時間は活動時間内でなければなりません")
      expect(page).to have_content("予定の更新に失敗しました")
    end
  end
end
