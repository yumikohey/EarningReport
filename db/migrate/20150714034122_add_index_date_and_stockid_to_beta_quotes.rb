class AddIndexDateAndStockidToBetaQuotes < ActiveRecord::Migration
  def change
  	add_index :beta_quotes, :date
  	add_index :beta_quotes, :stock_id
  end
end
