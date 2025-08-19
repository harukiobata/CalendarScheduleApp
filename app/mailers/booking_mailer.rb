class BookingMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def confirmation_email
    @booking = params[:booking]
    zoom_url = nil

    if @booking.owner.zoom_connected?
      zoom_service = ZoomService.new(@booking.owner)
      meeting_data = zoom_service.create_meeting(
        topic: "予約: #{@booking.name}",
        start_time: @booking.start_time,
        duration: ((@booking.end_time - @booking.start_time) / 60).to_i
      )
      zoom_url = meeting_data["join_url"]
    end

    subject = "【予約確認】ご予約ありがとうございます"
    body = <<~TEXT
      #{@booking.name} 様

      ご予約ありがとうございます。
      以下の内容で承りました。

      開始: #{@booking.start_time.strftime('%Y年%m月%d日 %H:%M')}
      終了: #{@booking.end_time.strftime('%Y年%m月%d日 %H:%M')}

      #{zoom_url.present? ? "ZoomミーティングURL: #{zoom_url}" : ""}

      ---
      このメールは自動送信されています。
    TEXT

    mail(to: @booking.email, subject: subject, body: body)
  end
end
