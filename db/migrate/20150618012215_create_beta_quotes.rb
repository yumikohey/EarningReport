class CreateBetaQuotes < ActiveRecord::Migration
  def change
    create_table :beta_quotes do |t|
    	t.string :stock
    	t.date :date
    	t.float :open
    	t.float :high
    	t.float :low
    	t.float :close
    	t.integer :volume
    	t.integer :stock_id
    	
      t.timestamps null: false
    end
  end
end
