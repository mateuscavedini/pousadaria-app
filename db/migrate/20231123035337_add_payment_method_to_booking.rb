class AddPaymentMethodToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :payment_method, :string
  end
end
