class AddStatusToGuesthouse < ActiveRecord::Migration[7.1]
  def change
    add_column :guesthouses, :status, :integer, default: 0
  end
end
