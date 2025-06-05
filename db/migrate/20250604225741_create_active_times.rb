class CreateActiveTimes < ActiveRecord::Migration[7.2]
  def change
    create_table :active_times do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :granularity_minutes, null: false, default: 30

      t.timestamps
    end
  end
end
