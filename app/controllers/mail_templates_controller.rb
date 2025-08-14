class MailTemplatesController < ApplicationController
  before_action :authenticate_user!
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

  def set_mail_template
    @mail_template = current_user.mail_templates.find(params[:id])
  end

  def mail_template_params
    params.require(:mail_template).permit(:subject, :body)
  end
end
