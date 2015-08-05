class EreportsController < ApplicationController
	def er
		date = Date.today
		while date.saturday? || date.sunday? do
			date += 1
		end
		if date.tuesday?
			date -= 1
		elsif date.wednesday?
			date -= 2
    elsif date.thursday?
    	date -= 3
    elsif date.friday?
    	date -= 4
    end
		
		a_week = [date]
		i = 0
		while i < 4 do
			date += 1
			a_week.push(date)
			p date
			i += 1
		end
		@stocks = []
		a_week.each do |weekday|
			single_day = []
			# need to update DB's stock market capital in order to do sorting at backend
			reports = Ereport.where(date:weekday).limit(20)
			reports.each do |report|
				stock = Stock.find(report.stock_id)
				single_day.push(stock)
			end
			@stocks.push(single_day)
		end
		render json: @stocks 
	end

end
