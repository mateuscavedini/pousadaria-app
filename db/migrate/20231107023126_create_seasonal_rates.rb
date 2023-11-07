class CreateSeasonalRates < ActiveRecord::Migration[7.1]
  def change
    create_table :seasonal_rates do |t|
      t.date :start_date
      t.date :finish_date
      t.decimal :rate, precision: 8, scale: 2
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
