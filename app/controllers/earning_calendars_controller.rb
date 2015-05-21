class EarningCalendarsController < ApplicationController
	include EarningCalendarsHelper
	def month_er
		EarningCalendarsHelper.import
		render 'text'
	end

	def index
		@stocks = EarningCalendar.where(day:Date.today.next_day)
		render 'index'
	end

	def record_earning_dates
		date = Date.today - 2
		date_str = date.to_s.split("-").join("")
		url = "http://biz.yahoo.com/research/earncal/#{date_str}.html"
		h = {}
		array = []
		begin
			page = Nokogiri::HTML(open(url))
		rescue
			p "404 page"
		else
			page.xpath('//a[@href]').each do |link|
			  h[link.text.strip] = link['href']
			end
			h.each do |key, value|
				if !Stock.where(symbol:key).empty?
					stock = Stock.where(symbol:key)[0]
					Ereport.create(symbol:key, date:date, stock_id:stock.id)
					array.push(key)
				end
			end
		end
		render 'text'
	end

	# def record_earning_dates
	# 	# require 'yahoo_stock'
	# 	# quote = YahooStock::Quote.new(:stock_symbols => ['AAPL'])
	# 	# history = YahooStock::History.new(:stock_symbol => 'AAPL', :start_date => Date.today-20, :end_date => Date.today-2)
	# 	counter = 1597
	# 	while(counter < 1596)
	# 		date = Date.today - counter
	# 		date_str = date.to_s.split("-").join("")
	# 		url = "http://biz.yahoo.com/research/earncal/#{date_str}.html"
	# 		h = {}
	# 		begin
	# 			page = Nokogiri::HTML(open(url))
	# 		rescue
	# 			p "404 page"
	# 		else
	# 			page.xpath('//a[@href]').each do |link|
	# 			  h[link.text.strip] = link['href']
	# 			end
	# 			h.each do |key, value|
	# 				if !Stock.where(symbol:key).empty?
	# 					stock = Stock.where(symbol:key)[0]
	# 					Ereport.create(symbol:key, date:date, stock_id:stock.id)
	# 				end
	# 			end
	# 		end
	# 	counter += 1
	# 	end
	# 	render 'text'
	# end

	private
	  def ereports_params
	    params.require(:ereport).permit(:symbol, :date, :stock_id)
	  end
end
