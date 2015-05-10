class CreatePutCallRatios < ActiveRecord::Migration
  def change
    create_table :put_call_ratios do |t|
      t.date :date
      t.integer :calls
      t.integer :puts
      t.integer :total
      t.decimal :pcratio
      t.string :symbol
      t.integer :stock_id
      t.timestamps null: false
    end
  end
end
