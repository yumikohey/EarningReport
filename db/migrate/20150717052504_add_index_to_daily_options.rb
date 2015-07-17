class AddIndexToDailyOptions < ActiveRecord::Migration
  def change
  	add_index :daily_options, :symbol
  end
end
