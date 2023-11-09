class AddStatusToSeasonalRate < ActiveRecord::Migration[7.1]
  def change
    add_column :seasonal_rates, :status, :integer, default: 0
  end
end
