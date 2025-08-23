class AddZoomUrlsToBookings < ActiveRecord::Migration[7.2]
  def change
    add_column :bookings, :zoom_join_url, :string
    add_column :bookings, :zoom_start_url, :string
  end
end
