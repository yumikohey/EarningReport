class AddIndexToPriceOnErs < ActiveRecord::Migration
  def change
  	add_index :price_on_ers, :ereport_id
  	add_index :price_on_ers, :price_date
  end
end
