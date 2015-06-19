class AddAvgToHistoryQuotes < ActiveRecord::Migration
  def change
    add_column :history_quotes, :five_avg, :float
    add_column :history_quotes, :ten_avg, :float
    add_column :history_quotes, :cross, :integer
  end
end
