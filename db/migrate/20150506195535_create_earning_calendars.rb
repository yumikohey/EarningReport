class CreateEarningCalendars < ActiveRecord::Migration
  def change
    create_table :earning_calendars do |t|
    	t.string :company_name
    	t.string :symbol
    	t.integer :stock_id
    	t.timestamps null: false
    end
  end
end
