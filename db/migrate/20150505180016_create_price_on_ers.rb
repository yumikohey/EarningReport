class CreatePriceOnErs < ActiveRecord::Migration
  def change
    create_table :price_on_ers do |t|
      t.date :price_date
      t.text :quote
      t.integer :ereport_id
      t.integer :volume

      t.timestamps null: false
    end
  end
end
