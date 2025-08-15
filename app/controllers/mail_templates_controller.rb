class MailTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_confirmation_template_exists
  before_action :set_mail_template, only: [ :edit, :update ]

  def index
    @mail_templates = current_user.mail_templates
  end

  def edit
  end

  def update
    if @mail_template.update(mail_template_params)
      redirect_to mail_templates_path, notice: "テンプレートを更新しました"
    else
      render :edit
    end
  end

  private

  def ensure_confirmation_template_exists
    current_user.mail_templates.find_or_create_by!(name: "confirmation_email") do |template|
      template.subject = "【予約確認】ご予約ありがとうございます"
      template.body = <<~TEXT
        <%= @booking.name %> 様

        ご予約ありがとうございます。
        以下の内容で承りました。

        開始: <%= @booking.start_time.strftime('%Y年%m月%d日 %H:%M') %>
        終了: <%= @booking.end_time.strftime('%Y年%m月%d日 %H:%M') %>

        ---
        このメールは自動送信されています。
      TEXT
    end
  end

  def set_mail_template
    @mail_template = current_user.mail_templates.find(params[:id])
  end

  def mail_template_params
    params.require(:mail_template).permit(:subject, :body)
  end
end
