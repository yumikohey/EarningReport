class AddIndexToPriceAfterErs < ActiveRecord::Migration
  def change
  	add_index :price_after_ers, :ereport_id
  	add_index :price_after_ers, :price_date
  end
end
