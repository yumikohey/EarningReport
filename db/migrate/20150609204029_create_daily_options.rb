class CreateDailyOptions < ActiveRecord::Migration
  def change
    create_table :daily_options do |t|
      t.string :symbol
      t.integer :stock_id
      t.date :expiration_date
      t.string :option_chains

      t.timestamps null: false
    end
  end
end
