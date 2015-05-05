class RemovePriceAfterErFromEreport < ActiveRecord::Migration
  def change
    remove_column :ereports, :price_after_er, :decimal
  end
end
