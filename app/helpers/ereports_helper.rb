module EreportsHelper

	def self.get_earning_report_dates(stock_symbol, stock_id, each_qrt, each_year)
		url = "http://www.estimize.com/#{stock_symbol}/fq#{each_qrt}-#{each_year}#chart=historical"
		begin 
			page = Nokogiri::HTML(open(url))
		rescue
			p "no reports for #{each_year} #{each_qrt}"
		else
			page.search('.date').map do |element|
				temp = (element.inner_text[0..-5]).split('/')
				date_str = (temp[1] +'/'+ temp[0] +'/20'+ temp[2]).to_s
				earning_report = Ereport.create(symbol:stock_symbol, date:date_str, stock_id:stock_id)
				p earning_report.stock_id
			end	
		end
	end

	def self.yahoo_url(stock_symbol, date_one, date_two, month_one, month_two, year)
		"http://finance.yahoo.com/q/hp?s=#{stock_symbol}&a=#{month_one}&b=#{date_one}&c=#{year}&d=#{month_two}&e=#{date_two}&f=#{year}&g=d"
	end

	def self.earning_report_dates_data(stock_symbol, earning)
		if PriceAfterEr.where(ereport_id:earning.id).empty? || PriceAfterEr.where(ereport_id:earning.id)[0].quote.empty?
			date = earning.date
			yesterday = date - 1
			tomorrow = date + 1
			require 'yahoo_stock'
			if (date.tomorrow.saturday?)
				tomorrow += 2
			elsif (date.yesterday.sunday?)
				yesterday -= 2
			end
			price_quotes = []
			if tomorrow < Date.today
				history = YahooStock::History.new(:stock_symbol => stock_symbol, :start_date => yesterday, :end_date => tomorrow)
				price_quotes = history.results(:to_array).output
				if price_quotes.length < 3
					if Date.parse(price_quotes[0][0]) != date && date.prev_day.monday?
						yesterday -= 3
					elsif Date.parse(price_quotes[0][0]) == date && date.next_day.friday?
						tomorrow += 3
					elsif Date.parse(price_quotes[0][0]) == date 
						tomorrow += 1
					elsif Date.parse(price_quotes[0][0]) != date
						yesterday -= 1
					end
					history = YahooStock::History.new(:stock_symbol => stock_symbol, :start_date => yesterday, :end_date => tomorrow)
					price_quotes = history.results(:to_array).output	
				end
			elsif date == Date.today && (PriceOnEr.where(ereport_id:earning.id).empty? || PriceOnEr.where(ereport_id:earning.id)[0].quote.empty?)
				history = YahooStock::History.new(:stock_symbol => stock_symbol, :start_date => yesterday, :end_date => yesterday)
				price_quotes = history.results(:to_array).output
				quote = YahooStock::Quote.new(:stock_symbols => [stock_symbol])
				quote.use_all_parameters
				today_data = quote.results(:to_hash).output
				open = today_data[0][:open].to_f
				high = today_data[0][:day_high].to_f
				low = today_data[0][:day_low].to_f
				close = today_data[0][:last_trade_price_only].to_f
				volume = today_data[0][:volume].to_i
				today_price = []	
				today_price.push(date)
				today_price.push(open)
				today_price.push(high)
				today_price.push(low)
				today_price.push(close)
				today_price.push(volume)
				price_quotes.unshift(today_price)
				p "today price #{today_price}"
				tomorrow_price = []
				price_quotes.unshift(tomorrow_price)
				p "price_quotes array: #{price_quotes}"
			elsif tomorrow == Date.today && (PriceAfterEr.where(ereport_id:earning.id, date:tomorrow).empty? || PriceAfterEr.where(ereport_id:earning.id, date:tomorrow)[0].quote.empty?)
				history = YahooStock::History.new(:stock_symbol => stock_symbol, :start_date => yesterday, :end_date => date)
				quote = YahooStock::Quote.new(:stock_symbols => [stock_symbol])
				price_quotes = history.results(:to_array).output
				quote.use_all_parameters
				all_data = quote.results(:to_hash).output
				open = all_data[0][:open].to_f
				high = all_data[0][:day_high].to_f
				low = all_data[0][:day_low].to_f
				close = all_data[0][:last_trade_price_only].to_f
				volume = all_data[0][:volume].to_i
				tomorrow_price = []
				today_price.push(tomorrow)
				tomorrow_price.push(open)
				tomorrow_price.push(high)
				tomorrow_price.push(low)
				tomorrow_price.push(close)
				tomorrow_price.push(volume)
				price_quotes.unshift(tomorrow_price)			
			end
			p price_quotes[2]
			price_before_er = PriceBeforeEr.create(ereport_id:earning.id)
			price_on_er = PriceOnEr.create(ereport_id:earning.id)
			price_after_er = PriceAfterEr.create(ereport_id:earning.id)
			price_before_er.price_date = yesterday
			price_before_er.save
			price_on_er.price_date = date
			price_on_er.save
			price_after_er.price_date = tomorrow
			price_after_er.save
			price_before_er.quote = price_quotes[2]
			price_before_er.save
			price_on_er.quote = price_quotes[1]
			price_on_er.save
			price_after_er.quote = price_quotes[0]
			price_after_er.save
		end
	end

end
