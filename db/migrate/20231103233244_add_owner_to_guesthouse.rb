class AddOwnerToGuesthouse < ActiveRecord::Migration[7.1]
  def change
    add_reference :guesthouses, :owner, null: false, foreign_key: true
  end
end
