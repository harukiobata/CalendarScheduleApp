class BookingMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def confirmation_email
    @booking = params[:booking]
    template = @booking.owner.mail_templates.find_by(name: "confirmation_email")
    mail(
      to: @booking.email,
      subject: template.subject,
      body: ERB.new(template.body).result(binding)
    )
  end
end
