class AddRecordDateToDailyOptions < ActiveRecord::Migration
  def change
    add_column :daily_options, :record_date, :date
  end
end
