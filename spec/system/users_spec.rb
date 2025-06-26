require "rails_helper"

RSpec.describe "ユーザー認証関連", type: :system, js: true do
  let!(:user) { create(:user, email: "taken@example.com") }

  before do
    visit new_user_registration_path
  end

  describe "新規登録" do
    it "有効な情報なら登録できる" do
      fill_in "ユーザー名 (20文字まで)", with: "testuser"
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード (6文字以上)", with: "password123"
      fill_in "パスワード (確認用)", with: "password123"
      click_button "新規登録"

      expect(page).to have_content "アカウント登録が完了しました"
      expect(page).to have_content "testuser"
    end

    it "無効な情報なら登録できない" do
      fill_in "ユーザー名 (20文字まで)", with: "test" * 6
      fill_in "メールアドレス", with: "taken@example.com"
      fill_in "パスワード (6文字以上)", with: "123456"
      fill_in "パスワード (確認用)", with: "234561"
      click_button "新規登録"

      expect(page).to have_content "ユーザー名は20文字以内で入力してください"
      expect(page).to have_content "Eメールはすでに存在します"
      expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
    end
  end

  describe "ログイン" do
    before do
      visit new_user_session_path
    end

    it "有効な情報ならログインできる" do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password123"
      click_button "ログイン"

      expect(page).to have_content user.username
    end

    it "パスワード,メールアドレスが違うとログインできない" do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "acacaca"
      click_button "ログイン"

      expect(page).to have_content "Eメールまたはパスワードが違います"
    end
  end

  describe "ユーザー編集情報" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password123"
      click_button "ログイン"
      find(".app-header__user-btn").click
      click_link "ユーザー情報編集"
    end

    it "正しい情報だと更新できる" do
      fill_in "ユーザー名 (20文字まで)", with: "updatedname"
      fill_in "メールアドレス", with: "updated@example.com"
      fill_in "新しいパスワード (6文字以上)", with: "123456"
      fill_in "新しいパスワード (確認用)", with: "123456"
      fill_in "現在のパスワード", with: "password123"
      click_button "情報の更新"

      expect(page).to have_content "アカウント情報を変更しました"
      expect(page).to have_content "updatedname"
    end

    it "無効な情報なら更新できない" do
      fill_in "ユーザー名 (20文字まで)", with: "a" * 30
      fill_in "メールアドレス", with: "updated@example.com"
      fill_in "新しいパスワード (6文字以上)", with: "123456"
      fill_in "新しいパスワード (確認用)", with: "345612"
      fill_in "現在のパスワード", with: "password13"
      click_button "情報の更新"

      expect(page).to have_content "ユーザー名は20文字以内で入力してください"
      expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
      expect(page).to have_content "現在のパスワードは不正な値です"
    end
  end
end
