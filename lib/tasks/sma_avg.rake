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

desc 'golden_cross'
task golden_cross: :environment do
	stocks = Stock.all
	include SmaAveragesHelper
	client = Twitter::REST::Client.new do |config|
	  config.consumer_key = ENV['CONSUMER_KEY']
	  config.consumer_secret = ENV['CONSUMER_SECRET']
	  config.access_token = ENV['ACCESS_TOKEN']
	  config.access_token_secret = ENV['ACCESS_SECRET']
	end
  stocks.each do |stock|
  	SmaAveragesHelper.golden_cross(stock)
	end
	total_golden_cross = BetaQuote.where(date:Date.today - 1, cross:1).count
	total_death_cross = BetaQuote.where(date:Date.today - 1, cross:-1).count
	total_upper = BetaQuote.where(date:Date.today - 1, cross:2).count
	total_downward = BetaQuote.where(date:Date.today - 1, cross:-2).count
	client.update("$SPY $AAPL #{total_golden_cross} stocks appeared golden cross #{Date.today - 1} more info, please check http://options-er.herokuapp.com/golden")
	client.update("$SPY $AAPL #{total_death_cross} stocks appeared death cross #{Date.today - 1} more info, please check http://options-er.herokuapp.com/death")
	client.update("$SPY $AAPL #{total_upper} stocks are in upward trend #{Date.today - 1} more info, please check http://options-er.herokuapp.com")
	client.update("$SPY $AAPL #{total_downward} stocks are in downward trend #{Date.today - 1} more info, please check http://options-er.herokuapp.com")
end

desc 'calculate five days average'
task five_avg_daily: :environment do
	include SmaAveragesHelper
	stocks = Stock.all
  stocks.each do |stock|
  	SmaAveragesHelper.five_ten_avg(stock)
	end
end

desc 'update beta database' 
	task update_db: :environment do
		stocks = Stock.all
		end_date = Date.parse('2015-05-26')
		stocks.each do |stock|
			begin 
				start_date = Date.today - 2
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
						five_avg = five_days_total / 5

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
					p "#{stock.symbol}"
				else
					p "not a valid stock #{stock.symbol}"
				end
		  rescue
			  p "no more data for this stock #{stock.symbol}"
		  end
	  end
 end



