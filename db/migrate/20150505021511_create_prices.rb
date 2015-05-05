class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
    	  t.date :er_release_date
    		t.text :price_before_er
    		t.text :price_on_er
    	  t.text :price_after_er
    	  t.integer :ereport_id

    	  t.timestamps null: false
    end
  end
end
