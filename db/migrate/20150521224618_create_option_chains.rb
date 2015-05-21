class CreateOptionChains < ActiveRecord::Migration
  def change
    create_table :option_chains do |t|
    	t.string :symbol
      t.integer :stock_id
      t.date :expiration_date
      t.string :option_chains

      t.timestamps null: false
    end
  end
end
