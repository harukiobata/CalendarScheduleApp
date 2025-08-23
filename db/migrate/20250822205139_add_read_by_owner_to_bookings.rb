class AddReadByOwnerToBookings < ActiveRecord::Migration[7.2]
  def change
    add_column :bookings, :read_by_owner, :boolean, default: false, null: false
  end
end
