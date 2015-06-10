class AddNamesToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :name, :string
    add_column :stocks, :lastsale, :string
    add_column :stocks, :market_cap, :string
    add_column :stocks, :ipo_year, :integer
    add_column :stocks, :sector, :string
    add_column :stocks, :industry, :string
    add_column :stocks, :summary_quote, :string
  end
end
