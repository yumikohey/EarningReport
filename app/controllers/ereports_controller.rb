class EreportsController < ApplicationController
	def er
		date = Date.today + 1
		while date.saturday? || date.sunday? do
			date += 1
		end
		reports = Ereport.where(date:date)
		@stocks = []
		reports.each do |report|
			stock = Stock.find(report.stock_id)
			@stocks.push(stock)
		end
	end

end
