class AddIpodatesToStocks < ActiveRecord::Migration
  def change
  	add_column :stocks, :ipodate, :date
  end
end
