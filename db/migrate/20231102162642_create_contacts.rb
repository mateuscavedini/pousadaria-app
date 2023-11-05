class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :phone
      t.string :email
      t.references :guesthouse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
