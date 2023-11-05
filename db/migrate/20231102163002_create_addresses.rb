class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street_name
      t.string :street_number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :postal_code
      t.references :guesthouse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
