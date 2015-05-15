class StocksController < ApplicationController
	include EreportsHelper
	include StocksHelper

	def index
		render 'index'
	end

	def create
		stock_symbol = params[:symbol].upcase
		stock = Stock.where(symbol:stock_symbol)[0]
		# all_reports = stock.ereports
 		@all_ers = stock.ereports
 		@all_ers.each do |earning|
 			EreportsHelper.earning_report_dates_data(stock_symbol, earning)
 		end
 		this_stock = Stock.where(symbol:stock_symbol)[0]
 		@all_reports = this_stock.ereports
 	  redirect_to "/stocks/#{stock_symbol}"
 	# end
 end

 def show
		@stock = params[:symbol].upcase
		stock = Stock.where(symbol:params[:symbol])[0]
		@all_ers = stock.ereports
		@all_ers.each do |earning|
			EreportsHelper.earning_report_dates_data(stock.symbol, earning)
		end			
		@all_reports = stock.ereports
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
