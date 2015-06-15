desc 'download historical prices for stocks'
task history_quotes: :environment do
    require 'yahoo_stock'

    begin_date = Date.parse('2010-01-01')
    end_date = Date.parse('2015-06-13')
    stock_list = Stock.all
    stock_list.each do |stock|
    	p stock.symbol
    	  begin
	    		history = YahooStock::History.new(:stock_symbol => stock.symbol, :start_date => begin_date, :end_date => end_date)
	    		price_quotes = history.results(:to_hash).output
  		    begin
  			  	price_quotes.each do |day_quote|
  			  		HistoryQuote.create!(stock: stock, date: Date.parse(day_quote[:date]), open:day_quote[:open].to_f, high:day_quote[:high].to_f, low:day_quote[:low].to_f, close:day_quote[:close].to_f, volume:day_quote[:volume].to_i, stock_id:stock.id)
  			  	end
  			  rescue
  			  	p "errors #{stock.symbol}"
  			  end
		    	puts "#{stock.symbol} IPO date is #{Date.parse(price_quotes.last[:date])}"
		    	stock.ipodate = Date.parse(price_quotes.last[:date])
		    	stock.save
		    	p "done stock #{stock.symbol}"
	    	rescue
    		  File.open("log/history.txt","a") do |f|
            puts "writing logs #{stock.symbol}"
            f.write "\n #{stock.symbol} doesn't have historical quotes"
          end
	    	end 		    
	  end
end