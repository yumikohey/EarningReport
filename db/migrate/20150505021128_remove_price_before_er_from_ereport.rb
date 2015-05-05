class RemovePriceBeforeErFromEreport < ActiveRecord::Migration
  def change
    remove_column :ereports, :price_before_er, :decimal
  end
end
