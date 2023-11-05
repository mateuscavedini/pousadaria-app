class AddPaymentMethodsToGuesthouse < ActiveRecord::Migration[7.1]
  def change
    add_column :guesthouses, :payment_methods, :string
  end
end
