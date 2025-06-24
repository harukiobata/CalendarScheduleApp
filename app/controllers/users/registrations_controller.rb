class Users::RegistrationsController < Devise::RegistrationsController
  before_action :reject_guest_user, only: [ :edit, :update, :destroy ]

  private

  def reject_guest_user
    if current_user.email == "guest@example.com"
      redirect_to root_path, alert: "ゲストユーザーは編集,削除ができません"
    end
  end
end
