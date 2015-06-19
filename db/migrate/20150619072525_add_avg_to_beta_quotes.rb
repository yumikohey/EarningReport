class AddAvgToBetaQuotes < ActiveRecord::Migration
  def change
    add_column :beta_quotes, :five_avg, :float
    add_column :beta_quotes, :ten_avg, :float
    add_column :beta_quotes, :cross, :integer
  end
end
