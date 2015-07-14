class AddIndexDateAndStockidToHistoryQuotes < ActiveRecord::Migration
  def change
  	add_index :history_quotes, :date
  	add_index :history_quotes, :stock_id
  end
end
