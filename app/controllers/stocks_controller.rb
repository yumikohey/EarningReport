class StocksController < ApplicationController
	include EreportsHelper
	include StocksHelper

	def index
		if !Ereport.where(date:Time.zone.today).empty?
			@earnings = Ereport.where(date:Time.zone.today)
		end
		p @earnings
		render 'index'
	end

	def create
		stock_symbol = params[:symbol].upcase
		stock = Stock.where(symbol:stock_symbol)[0]
 		@all_ers = stock.ereports
 		@all_ers.each do |earning|
 			EreportsHelper.earning_report_dates_data(stock_symbol, earning)
 		end
 		this_stock = Stock.where(symbol:stock_symbol)[0]
 		@all_reports = this_stock.ereports.order('date DESC')
 		require 'yahoo_stock'
	 	quote = YahooStock::Quote.new(:stock_symbols => [stock_symbol])
	 	@current_price = quote.results(:to_array).output
 	  redirect_to "/stocks/#{stock_symbol}"
 end

 def show
		@stock = params[:symbol].upcase
		stock = Stock.where(symbol:params[:symbol])[0]
		@all_ers = stock.ereports.order('date DESC')
		p @all_ers.first
		@all_ers.each do |earning|
			EreportsHelper.earning_report_dates_data(stock.symbol, earning)
		end			
		@all_reports = stock.ereports.order('date DESC')
		require 'yahoo_stock'
		quote = YahooStock::Quote.new(:stock_symbols => [@stock])
	 	@current_price = quote.results(:to_array).output
		render 'show'
	end

	def upcoming_er
		StocksHelper.read_yahoo_data
	end

	private
	  def ereports_params
	    params.require(:ereport).permit(:symbol, :date, :before_or_after_hour, :stock_id)
	  end

end
