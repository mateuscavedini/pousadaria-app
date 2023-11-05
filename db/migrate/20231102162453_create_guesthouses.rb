class CreateGuesthouses < ActiveRecord::Migration[7.1]
  def change
    create_table :guesthouses do |t|
      t.string :corporate_name
      t.string :trading_name
      t.string :registration_number
      t.text :description
      t.boolean :allow_pets
      t.text :usage_policy
      t.time :check_in
      t.time :check_out

      t.timestamps
    end
  end
end
