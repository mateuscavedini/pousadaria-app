class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.integer :area
      t.integer :max_capacity
      t.integer :daily_rate
      t.boolean :has_bathroom
      t.boolean :has_balcony
      t.boolean :has_air_conditioner
      t.boolean :has_tv
      t.boolean :has_wardrobe
      t.boolean :has_safe
      t.boolean :is_accessible
      t.references :guesthouse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
