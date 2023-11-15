class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :guest, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.string :code
      t.decimal :total_price, precision: 8, scale: 2
      t.date :start_date
      t.date :finish_date
      t.integer :status, default: 0
      t.datetime :check_in
      t.datetime :check_out

      t.timestamps
    end
  end
end
