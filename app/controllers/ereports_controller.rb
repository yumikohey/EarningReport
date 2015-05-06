class EreportsController < ApplicationController
	def create
		require 'open-uri'
		search_result = Stock.where(symbol:params[:symbol])

		if search_result.empty?
			@stock = Stock.new(symbol:params[:symbol])
			@stock.save
			p "stock stored in db, where stock_id = #{@stock.id}"
			qrt = [1,2,3,4]
			year = [2012, 2013, 2014, 2015]
			year.each do |each_year|
				qrt.each do |each_qrt|
					url = "http://www.estimize.com/#{params[:symbol]}/fq#{each_qrt}-#{each_year}#chart=historical"
					begin 
						page = Nokogiri::HTML(open(url))
					rescue
						p "no reports for #{each_year} #{each_qrt}"
					else
						page.search('.date').map do |element|
							temp = (element.inner_text[0..-5]).split('/')
							date_str = (temp[1] +'/'+ temp[0] +'/20'+ temp[2]).to_s
							earning_report = Ereport.create(symbol:params[:symbol], date:date_str, stock_id:@stock.id)
							p earning_report.stock_id
						end	
					end
				end
			end
			@all_ers = search_result[0].ereports
			begin
			@stock = @all_ers.first.symbol
			rescue
				p "no result"
			else
				p "do nothing"
			end
			@html = []
			@all_ers.each do |earning|
				the_day = earning.date
				if the_day <= Date.today
					formatted_date = the_day.strftime("%m/%d/%Y").to_s.split("/")
					month = formatted_date[0].to_i
					date = formatted_date[1].to_i
					year = formatted_date[2].to_i
					if (the_day.month == the_day.next_day.month) && (!the_day.next_day.saturday?) && (the_day.month == the_day.prev_day.month)
						url = "http://finance.yahoo.com/q/hp?s=#{@stock}&a=#{month-1}&b=#{date-1}&c=#{year}&d=#{month-1}&e=#{date+1}&f=#{year}&g=d"
					elsif (the_day.month != the_day.prev_day.month) && (!the_day.next_day.saturday?)
						special_date = the_day.prev_month.end_of_month.strftime('%Y/%m/%d').to_s.split('/')
						url = "http://finance.yahoo.com/q/hp?s=#{@stock}&a=#{month-2}&b=#{special_date[2].to_i}&c=#{year}&d=#{month-1}&e=#{date+1}&f=#{year}&g=d"
					elsif (the_day.month != the_day.prev_day.month) && (the_day.next_day.saturday?)
						special_date = the_day.prev_month.end_of_month.strftime('%Y/%m/%d').to_s.split('/')
						url = "http://finance.yahoo.com/q/hp?s=#{@stock}&a=#{month-2}&b=#{special_date[2].to_i}&c=#{year}&d=#{month-1}&e=#{date+3}&f=#{year}&g=d"						
					elsif (the_day.month != the_day.next_day.month) && (!the_day.next_day.saturday?) && (the_day.month == the_day.prev_day.month)
						url = "http://finance.yahoo.com/q/hp?s=#{@stock}&a=#{month-1}&b=#{date-1}&c=#{year}&d=#{month}&e=1&f=#{year}&g=d"
					elsif (the_day.month != the_day.next_day.month) && (the_day.next_day.saturday?) && (the_day.month == the_day.prev_day.month)
						url = "http://finance.yahoo.com/q/hp?s=#{@stock}&a=#{month-1}&b=#{date-1}&c=#{year}&d=#{month}&e=3&f=#{year}&g=d"
					elsif (the_day.month == the_day.next_day.month) && (the_day.next_day.saturday?) && (the_day.month == the_day.prev_day.month)
						url = "http://finance.yahoo.com/q/hp?s=#{@stock}&a=#{month-1}&b=#{date-1}&c=#{year}&d=#{month-1}&e=#{date+3}&f=#{year}&g=d"
					end
					p "#{the_day} #{url}"
					page = Nokogiri::HTML(open(url))
					page.search('.yfnc_datamodoutline1').map do |element|
						# @html.push(element.inner_html)
						pricing_array = []
						price_before_er = PriceBeforeEr.create(ereport_id:earning.id)
						price_on_er = PriceOnEr.create(ereport_id:earning.id)
						price_after_er = PriceAfterEr.create(ereport_id:earning.id)
						array_of_quotes = element.css('.yfnc_tabledata1')
						array_of_quotes.each do |quote|
							p html_str = quote.inner_text
							if  html_str.match('[a-zA-Z]{3}\s\d{1,2}\,\s\d{4}')
								er_date = Date.parse(html_str)
								if er_date < the_day
									price_before_er.price_date = er_date
									price_before_er.save
								elsif er_date > the_day
									price_after_er.price_date = er_date
									price_after_er.save
								else
									price_on_er.price_date = er_date
									price_on_er.save
								end
							elsif html_str.match('\d*\.\d*')
								price = html_str.to_f
								if price_before_er.price_date && (price_before_er.quote.length != 5)
									price_before_er.quote.push(price)
									price_before_er.save
								elsif price_after_er.price_date && (price_after_er.quote.length != 5)
									price_after_er.quote.push(price)
									price_after_er.save
								elsif ( price_on_er.quote.length != 5)
									price_on_er.quote.push(price)
									price_on_er.save
								end

							else
								stock_volume = html_str.tr(",","").to_i
								p "this volume"
								if price_before_er.price_date
									price_before_er.volume = stock_volume
									price_before_er.save
								elsif price_on_er.price_date
									price_on_er.volume = stock_volume
									price_on_er.save
								elsif price_after_er.price_date
									price_after_er.volume = stock_volume
									price_after_er.save
								end
							end

						end
					end
				else
					p the_day
				end
			end
			@all_reports = @stock.ereports
			render 'stocks/show'
		else
			@stock = params[:symbol]
			@stock_info = Stock.where(symbol:params[:symbol])[0]
			@all_reports = @stock_info.ereports
			@no_report = false
			if @all_reports.count == 0
				@no_report = true
			end
			p @no_report
			render 'stocks/show'
		end
	end

	private
	  def ereports_params
	    params.require(:ereport).permit(:symbol, :date, :before_or_after_hour, :stock_id)
	  end

end
