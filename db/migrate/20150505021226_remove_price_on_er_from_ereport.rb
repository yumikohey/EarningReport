class RemovePriceOnErFromEreport < ActiveRecord::Migration
  def change
    remove_column :ereports, :price_on_er, :decimal
  end
end
