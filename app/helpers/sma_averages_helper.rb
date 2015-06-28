module SmaAveragesHelper
	def five_ten_avg(stock)
  	start_date = Date.today - 1
  		five_days = []
  		ten_start_date = start_date
  		while (start_date.saturday? || start_date.sunday?) do
  			start_date -= 1
  		end
  		beta_stock = BetaQuote.find_by(date:start_date, stock_id:stock.id)
  		p beta_stock
  		count = BetaQuote.where("date <= ? AND stock_id = ?", start_date, stock.id).count
  		p "count is: #{count}"
  		if beta_stock && count >= 11
		  		five_days.push(beta_stock.close.to_f)
		  		temp_date = start_date - 1
		  		begin
		  			while five_days.count < 5 do 
		  				while (temp_date.saturday? || temp_date.sunday?) do
		  					temp_date -= 1
		  				end
		  				temp_stock = BetaQuote.find_by(date:temp_date, stock_id:stock.id)
		  				five_days.push(temp_stock.close.to_f) if temp_stock
		  				# p "#{stock.symbol} #{temp_date} #{temp_stock.close.to_f.round(2)}"
		  				ten_start_date = temp_date
		  				temp_date -= 1
		  			end
		  		rescue
		  			p "end five days #{start_date}"
		  		end

		  		ten_days = five_days.dup
		  		begin
		  			while ten_days.count < 10 do 
		  				ten_start_date -= 1
		  				while (ten_start_date.saturday? || ten_start_date.sunday?) do
		  					ten_start_date -= 1
		  				end
		  				temp_stock = BetaQuote.find_by(date:ten_start_date, stock_id:stock.id)
		  				ten_days.push(temp_stock.close.to_f) if temp_stock
		  				#p "#{stock.symbol} #{ten_start_date} #{temp_stock.close.to_f.round(2)}"
		  			end	
		  		rescue
		  			p "end ten days #{ten_start_date}"
		  		end		

		  		
		  		five_days_total = 0
		  		five_days.each do |day|
		  			five_days_total += day
		  		end
		  		five_avg = five_days_total / 5

		  		ten_days_total = 0
		  		ten_days.each do |day|
		  			ten_days_total += day
		  		end
		  		ten_avg = ten_days_total / 10
		  		
		  		beta_stock.five_avg = five_avg
		  		beta_stock.ten_avg = ten_avg
		  		beta_stock.save
		  		p beta_stock
			  p stock.symbol
			else
				p "no data for #{stock.symbol}"
			end
	end

	def golden_cross(stock)
		end_date = Date.today - 2
		begin 
			cross = 0
			start_date = Date.today - 1
			while(start_date > end_date) do
				prev_date = start_date - 1
				while(prev_date.saturday? || prev_date.sunday?) do
					prev_date -= 1
				end
				stock_prev_day = BetaQuote.find_by(date:prev_date, stock_id:stock.id)

				while(start_date.saturday? || start_date.sunday?) do
					start_date -= 1
			  end
			  stock_today = BetaQuote.find_by(date:start_date, stock_id:stock.id)
			  # p stock_prev_day
			  # p stock_today
			  prev_sum = stock_prev_day.five_avg - stock_prev_day.ten_avg
			  today_sum = stock_today.five_avg - stock_today.ten_avg
			  	if prev_sum >= 0 && today_sum <= 0
			  		cross = -1
			  		p "#{stock.symbol} death cross"
			  		stock_today.cross = cross
			  		stock_today.save

			  	elsif prev_sum <= 0 && today_sum >= 0
			  		cross = 1
			  		p "#{stock.symbol} death cross"
			  		stock_today.cross = cross
			  		stock_today.save
			  	elsif today_sum < 0
			  		cross = -2
			  		p "downward trend"
			  		stock_today.cross = cross
			  		stock_today.save
			  	elsif today_sum > 0
			  		cross = 2
			  		p "upward trend"
			  		stock_today.cross = cross
			  		stock_today.save
			  	end
			  start_date -= 1
			end
		rescue
			p "no work!"
		end
	end
end
