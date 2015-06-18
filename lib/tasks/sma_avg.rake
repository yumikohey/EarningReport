desc 'calculate five days average'
task five_avg: :environment do

 #  require 'yahoo_stock'
 #  stock = Stock.find_by(symbol:'SPY')
 #  begin_date = Date.parse('2015-05-01')
 #  end_date = Date.today - 1
 #  begin
	# 	history = YahooStock::History.new(:stock_symbol => stock.symbol, :start_date => begin_date, :end_date => end_date)
	# 	price_quotes = history.results(:to_hash).output
 #    begin
	#   	price_quotes.each do |day_quote|
	#   		HistoryQuote.create!(stock: stock, date: Date.parse(day_quote[:date]), open:day_quote[:open].to_f, high:day_quote[:high].to_f, low:day_quote[:low].to_f, close:day_quote[:close].to_f, volume:day_quote[:volume].to_i, stock_id:stock.id)
	#   	end
	#   rescue
	#   	p "errors #{stock.symbol}"
	#   end
 #  	puts "#{stock.symbol} IPO date is #{Date.parse(price_quotes.last[:date])}"
 #  	stock.ipodate = Date.parse(price_quotes.last[:date])
 #  	stock.save
 #  	p "done stock #{stock.symbol}"
	# rescue
	#   File.open("log/history.txt","a") do |f|
 #      puts "writing logs #{stock.symbol}"
 #      f.write "\n #{stock.symbol} doesn't have historical quotes"
 #    end
 #  end
  stock = Stock.find_by(symbol:'SPY')
 	days = (0..40).to_a
  today = Date.today - 1
  days.each do |day|
  	start_date = today - day
  	five_start_date = today - day
  	ten_start_date = today - day  
		  five_days = []
		  ten_days = []
		  while(five_days.count < 5)
		  		a = HistoryQuote.find_by("stock_id=? AND date = ?", stock.id, five_start_date)
		  		if a
		  			five_days.push(a)
		  			p "#{a.date} #{a.close}"
		  		end
		  		five_start_date -= 1
		  end
		  while(ten_days.count < 10)
		  		b = HistoryQuote.find_by("stock_id=? AND date = ?", stock.id, ten_start_date)
		  		if b
		  			ten_days.push(b)
		  			p "#{b.date} #{b.close}"
		  		end
		  		ten_start_date -= 1
		  end
		  # if !today.friday?
		  # 	five_days = HistoryQuote.where("stock_id=? AND date <= ? AND date >= ?", 7160, start_date, start_date - 6)
		  # 	ten_days = HistoryQuote.where("stock_id=? AND date <= ? AND date >= ?", 7160, start_date, start_date - 13)
		  # else
		  # 	five_days = HistoryQuote.where("stock_id=? AND date <= ? AND date >= ?", 7160, start_date, start_date - 4)
		  # 	ten_days = HistoryQuote.where("stock_id=? AND date <= ? AND date >= ?", 7160, start_date, start_date - 9)
		  # end
		  p "five days array count : #{five_days.count} "
		  p "ten days array count : #{ten_days.count} "
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
		  	p "five days avg #{five_avg}"
		  	p "ten days avg #{ten_avg}"
		  	SmaAverage.create!(stock:stock, date:start_date, five_avg:five_avg, ten_avg:ten_avg, cross:0, stock_id:stock.id)
	end
end

desc 'golden_cross'
task golden_cross: :environment do
	stock = Stock.find_by(symbol:'SPY')
	today = Date.today - 1
	days = (0..40).to_a
	days.each do |day|
		cross = 0
		start_date = today - day
		stock_prev_day = SmaAverage.find_by(date:start_date-1, stock_id:stock.id)
		stock_today = SmaAverage.find_by(date:start_date, stock_id:stock.id)
		prev_sum = stock_prev_day.five_avg - stock_prev_day.ten_avg
		today_sum = stock_today.five_avg - stock_today.ten_avg
		if prev_sum >= 0 && today_sum <= 0
			cross = -1
			p "#{stock_today.date} Death Cross"
			stock_today.cross = cross
			stock_today.save
		elsif prev_sum <= 0 && today_sum >= 0
			cross = 1
			p "#{stock_today.date} golden_cross"
			stock_today.cross = cross
			stock_today.save
		elsif today_sum < 0
			p "downward trend"
		elsif today_sum > 0
			p "upward trend"
		end
	end

end