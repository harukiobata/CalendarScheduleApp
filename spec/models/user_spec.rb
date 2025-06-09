require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '有効なデータだと有効になる' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'ユーザー名が空だと無効になる' do
      user = build(:user, username: '')
      expect(user).to be_invalid
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'ユーザー名が21文字だと無効になる' do
      user = build(:user, username: 'あ' * 21)
      expect(user).to be_invalid
      expect(user.errors[:username]).to include('は20文字以内で入力してください')
    end

    it 'メールアドレスが空だと無効になる' do
      user = build(:user, email: '')
      expect(user).to be_invalid
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'パスワードが6文字未満だと無効になる' do
      user = build(:user, password: '12345', password_confirmation: '12345')
      expect(user).to be_invalid
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end

    it 'パスワードとパスワード(確認用)が違うと無効になる' do
      user = build(:user, password: 'password123', password_confirmation: 'different123')
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end

    it "ユーザー作成時に7件の活動時間が自動生成される" do
      user = create(:user)
      expect(user.active_times.count).to eq(7)
    end
  end
end
