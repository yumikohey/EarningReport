class Stock < ActiveRecord::Base
	has_many :ereports
	has_many :price_before_ers, through: :ereport
	has_many :price_on_ers, through: :ereport
	has_many :price_after_ers, through: :ereport
	has_many :earning_calendars
	has_many :put_call_ratios
	has_many :option_chains
	has_many :daily_options
	has_many :history_quotes
	has_many :sma_averages
	has_many :beta_quotes
end
