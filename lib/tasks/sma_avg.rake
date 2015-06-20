desc 'download past months average'
task one_month: :environment do
	  require 'yahoo_stock'
	  stocks = Stock.all
	  stocks.each do |stock|
		  begin_date = Date.parse('2015-05-01')
		  end_date = Date.parse('2015-06-17')
		  begin
				history = YahooStock::History.new(:stock_symbol => stock.symbol, :start_date => begin_date, :end_date => end_date)
				price_quotes = history.results(:to_hash).output
		    begin
			  	price_quotes.each do |day_quote|
			  		BetaQuote.create!(stock: stock, date: Date.parse(day_quote[:date]), open:day_quote[:open].to_f, high:day_quote[:high].to_f, low:day_quote[:low].to_f, close:day_quote[:close].to_f, volume:day_quote[:volume].to_i, stock_id:stock.id)
			  	end
			  rescue
			  	p "errors #{stock.symbol}"
			  end
		  	#puts "#{stock.symbol} IPO date is #{Date.parse(price_quotes.last[:date])}"
		  	#stock.ipodate = Date.parse(price_quotes.last[:date])
		  	#stock.save
		  	p "done stock #{stock.symbol}"
		  rescue
			  File.open("log/history.txt","a") do |f|
		      puts "writing logs #{stock.symbol}"
		      f.write "\n #{stock.symbol} doesn't have historical quotes"
		    end
		  end
		end
end

desc 'calculate five days average'
task five_avg: :environment do
  stocks = Stock.all
  days = (0..25).to_a
  stocks.each do |stock|
	  today = Date.today - 1
	  quotes_count = BetaQuote.where(stock_id:stock.id).count
	  if quotes_count >= 25
	    days.each do |day|
		  	start_date = today - day
		  	five_start_date = today - day
		  	ten_start_date = today - day  
				  five_days = []
				  ten_days = []
				  while(five_days.count < 5)
				  		a = BetaQuote.find_by("stock_id=? AND date = ?", stock.id, five_start_date)
				  		if a
				  			five_days.push(a)
				  			# p "#{a.date} #{a.close}"
				  		end
				  		five_start_date -= 1
				  end
				  while(ten_days.count < 10)
				  		b = BetaQuote.find_by("stock_id=? AND date = ?", stock.id, ten_start_date)
				  		if b
				  			ten_days.push(b)
				  			# p "#{b.date} #{b.close}"
				  		end
				  		ten_start_date -= 1
				  end

				  if !five_days.empty? && !ten_days.empty?
					  # p "five days array count : #{five_days.count} "
					  # p "ten days array count : #{ten_days.count} "
					  	five_days_total = 0
					  	ten_days_total = 5
					  	five_days.each do |day|
					  		five_days_total += day.close.to_f
					  	end
					  	ten_days.each do |day|
					  		ten_days_total += day.close.to_f
					  	end
					  	
					  	five_avg = five_days_total / five_days.count
					  	ten_avg = ten_days_total / ten_days.count
					  	# p "five days avg #{five_avg}"
					  	# p "ten days avg #{ten_avg}"
					  	#SmaAverage.create!(stock:stock, date:start_date, five_avg:five_avg, ten_avg:ten_avg, cross:0, stock_id:stock.id)
					  	p update_stock = BetaQuote.find_by(date:start_date,stock_id:stock.id)
					  	if update_stock
						  	update_stock.five_avg = five_avg
						  	update_stock.ten_avg = ten_avg
						  	update_stock.save
						  end
					end
			end
		else
			p "no data for #{stock.symbol}"
		end
	end
end


desc 'golden_cross'
task golden_cross: :environment do
	stocks = Stock.all
	# stock = Stock.find(3281)
	today = Date.today
	end_date = Date.parse('2015-06-18')
	stocks.each do |stock|
		begin 
			cross = 0
			start_date = today
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
			  		p "#{stock.symbol} #{stock_today.date} Death Cross"
			  		stock_today.cross = cross
			  		stock_today.save
			  	elsif prev_sum <= 0 && today_sum >= 0
			  		cross = 1
			  		p "#{stock.symbol} #{stock_today.date} golden_cross"
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

desc 'calculate five days average'
task five_avg_daily: :environment do
  stocks = Stock.all
 	# stock = Stock.find_by(symbol:'AMZN')
  stocks.each do |stock|
  	start_date = Date.today
  		five_days = []
  		ten_start_date = start_date
  		while (start_date.saturday? || start_date.sunday?) do
  			start_date -= 1
  		end
  		beta_stock = BetaQuote.find_by(date:start_date, stock_id:stock.id)
  		count = BetaQuote.where("date <= ? AND stock_id = ?", start_date, stock.id).count
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
end

desc 'update beta database' 
	task update_db: :environment do
		stocks = Stock.all
		end_date = Date.parse('2015-05-26')
		
		stocks.each do |stock|
			begin 
				start_date = Date.today - 1
				count = BetaQuote.where(stock_id:stock.id).count
				if count > 25
					while start_date > end_date do
						five_days = []
						ten_start_date = start_date
						while (start_date.saturday? || start_date.sunday?) do
							start_date -= 1
						end
						beta_stock = BetaQuote.find_by(date:start_date, stock_id:stock.id)
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
						p five_avg = five_days_total / 5

						ten_days_total = 0
						ten_days.each do |day|
							ten_days_total += day
						end
						ten_avg = ten_days_total / 10
						
						beta_stock.five_avg = five_avg
						beta_stock.ten_avg = ten_avg
						beta_stock.save
						start_date -= 1
					end
				else
					p "not a valid stock #{stock.symbol}"
				end
		  rescue
			  p "no more data for this stock #{stock.symbol}"
		  end
	  end
 end



