class AddZoomFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :zoom_access_token, :string
    add_column :users, :zoom_refresh_token, :string
    add_column :users, :zoom_token_expires_at, :datetime
  end
end
