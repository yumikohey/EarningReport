class AddIndexToEreports < ActiveRecord::Migration
  def change
  	add_index :ereports, :symbol
  	add_index :ereports, :date
  end
end
