class ChangeDailyRateTypeInRoom < ActiveRecord::Migration[7.1]
  def change
    change_column :rooms, :daily_rate, :decimal, precision: 8, scale: 2
  end
end
