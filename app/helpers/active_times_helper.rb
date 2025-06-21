module ActiveTimesHelper
  def day_label(day_number)
    %w[月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日][(day_number -1) % 7]
  end
end
