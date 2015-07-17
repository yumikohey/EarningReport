class AddIndexToPriceBeforeErs < ActiveRecord::Migration
  def change
  	 add_index :price_before_ers, :ereport_id
  	 add_index :price_before_ers, :price_date
  end
end
