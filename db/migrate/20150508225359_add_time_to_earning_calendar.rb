class AddTimeToEarningCalendar < ActiveRecord::Migration
  def change
    add_column :earning_calendars, :time, :string
    add_column :earning_calendars, :day, :date
    add_column :earning_calendars, :eps, :string
  end
end
