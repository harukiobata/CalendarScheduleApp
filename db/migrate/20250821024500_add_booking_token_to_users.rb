class AddBookingTokenToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :booking_token, :string
    add_index :users, :booking_token, unique: true

    reversible do |dir|
      dir.up do
        User.reset_column_information
        User.find_each { |u| u.update!(booking_token: SecureRandom.urlsafe_base64(12)) unless u.booking_token }
      end
    end
  end
end
