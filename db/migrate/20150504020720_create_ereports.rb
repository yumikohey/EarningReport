class CreateEreports < ActiveRecord::Migration
  def change
    create_table :ereports do |t|
    	t.string :symbol
    	t.date :date
    	t.boolean :before_or_after_hour
    	t.decimal :price_before_er
    	t.decimal :price_on_er
      t.decimal :price_after_er
      t.integer :stock_id

      t.timestamps null: false
    end
  end
end
