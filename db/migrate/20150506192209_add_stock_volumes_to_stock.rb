class AddStockVolumesToStock < ActiveRecord::Migration
  def change
    add_column :stocks, :stock_volume, :integer
  end
end
