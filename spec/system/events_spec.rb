require 'rails_helper'

RSpec.describe "System/event", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:event) { create(:event, user:user) }

  before do
    sign_in user
    visit root_path
  end

  describe "new,index,destroy,editのそれぞれのアクションがしっかり動いている" do
    it "新規予定を作成できる" do
      within("turbo-frame#event_panel") do
        find_field("event-date").set(Date.current.strftime("%Y-%m-%d"))
        find_field("event-title").set("会議")
        find_field("event-start_time").set("10:00")
        find_field("event-end_time").set("11:00")
        click_button "作成"
      end
      within("section.event-section") do
        click_link "一覧表示"
      end
      expect(page).to have_content "会議"
    end

    it "予定が表示される" do
      within("section.event-section") do
        click_link "一覧表示"
      end
      within("turbo-frame#event_panel") do
        expect(page).to have_content event.title
      end
    end

    it "予定を削除できる" do
      within("section.event-section") do
        click_link "一覧表示"
      end
      within("turbo-frame#event_panel") do
        find("button.event-actions__toggle").click
        accept_confirm do
          click_link "削除"
        end
      end
      expect(page).not_to have_content event.title
    end

    it "予定を編集できる" do
      within("section.event-section") do
        click_link "一覧表示"
      end
      within("turbo-frame#event_panel") do
        find("button.event-actions__toggle").click
        click_link "編集"
      end
      find_field("event-title").set("編集された予定")
      click_button "更新"

      within("turbo-frame#event_panel") do
        expect(page).to have_content "編集された予定"
      end
    end
  end
end