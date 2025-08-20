class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.string :email, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.text :memo

      t.timestamps
    end
  end
end
