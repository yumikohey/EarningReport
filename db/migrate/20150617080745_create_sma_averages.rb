class CreateSmaAverages < ActiveRecord::Migration
  def change
    create_table :sma_averages do |t|
    	t.string :stock
    	t.date :date
    	t.float :five_avg
    	t.float :ten_avg
    	t.integer :cross
    	t.integer :stock_id
      t.timestamps null: false
    end
  end

  #cross = -1 => death
  #cross = 0 => neutral
  #cross = 1 => golden
end
