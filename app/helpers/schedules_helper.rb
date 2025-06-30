module SchedulesHelper
  CATEGORY_COLORS = {
    "重要" => "#e74c3c",
    "仕事" => "#3498db",
    "プライベート" => "#2ecc71",
    "その他" => "#95a5a6"
}.freeze

  def category_color(category_name)
    CATEGORY_COLORS[category_name]
  end
end
