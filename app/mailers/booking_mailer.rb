class BookingMailer < ApplicationMailer
  def confirmation_email
    @booking = params[:booking]
    subject = "【予約確認】ご予約ありがとうございます"

    body = <<~TEXT
      #{@booking.name} 様

      ご予約ありがとうございます。
      以下の内容で承りました。

      開始: #{@booking.start_time.strftime('%Y年%m月%d日 %H:%M')}
      終了: #{@booking.end_time.strftime('%Y年%m月%d日 %H:%M')}

      #{ "ZoomミーティングURL: #{@booking.zoom_join_url}" if @booking.zoom_join_url.present? }

      ---
      このメールは自動送信されています。
    TEXT

    mail(to: @booking.email, subject: subject, body: body)
  end

  def new_booking_notification
    @booking = params[:booking]
    @owner   = @booking.owner
    subject = "【新規予約】#{@booking.name} 様から予約が入りました"

    body = <<~TEXT
      #{@owner.username} 様

      新しい予約が入りました。

      予約者: #{@booking.name}
      メール: #{@booking.email}
      開始: #{@booking.start_time.strftime('%Y年%m月%d日 %H:%M')}
      終了: #{@booking.end_time.strftime('%Y年%m月%d日 %H:%M')}
      メモ: #{@booking.memo.presence || "（なし）"}
      #{ "Zoom開始URL: #{@booking.zoom_start_url}" if @booking.zoom_start_url.present? }

      ---
      このメールは自動送信されています。
    TEXT

    mail(to: @owner.email, subject: subject, body: body)
  end
end
