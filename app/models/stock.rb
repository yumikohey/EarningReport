class Stock < ActiveRecord::Base
	has_many :ereports
	has_many :price_before_ers, through: :ereport
	has_many :price_on_ers, through: :ereport
	has_many :price_after_ers, through: :ereport
	has_many :earning_calendars
end
