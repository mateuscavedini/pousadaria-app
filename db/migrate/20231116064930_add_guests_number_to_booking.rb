class AddGuestsNumberToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :guests_number, :integer
  end
end
