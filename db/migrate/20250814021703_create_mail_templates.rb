class CreateMailTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :mail_templates do |t|
      t.string :name
      t.string :subject
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
