class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :note
      t.date :date
      t.datetime :start_time
      t.datetime :end_time
      t.string :category
      t.string :location, null: true

      t.timestamps
    end
  end
end
