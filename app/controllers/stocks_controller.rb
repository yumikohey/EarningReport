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

	def options
		symbol = params[:symbol]
		url = "http://www.google.com/finance/option_chain?q=#{symbol}&output=json&expy=2015&expm=5&expd=22"
		response = HTTParty.get(url)
		json_data = response.body
		render json: json_data.to_json
	end

	def download_options
		stock_symbol = params[:option_chain][:symbol]
		expiry = Date.parse(params[:option_chain][:expiration_date])
		stock_id = Stock.where(symbol:stock_symbol)[0].id if !Stock.where(symbol:stock_symbol).empty?
		params[:stock_id] = stock_id
		option_chains = params[:option_chain][:option_chains]
		if OptionChain.where(symbol:stock_symbol, expiration_date:expiry).empty?
			OptionChain.create!(symbol:stock_symbol, stock_id:stock_id, expiration_date:expiry, option_chains:option_chains)
		end
			@option_chain = OptionChain.where(stock_id:stock_id, expiration_date:expiry)[0].option_chains
		# respond_to do |format|
		# 	format.html
		# 	format.json { render json: @option_chain }
		# end
		render 'option'
	end

	def current_pain
		render 'option'
	end

	private
	  def ereports_params
	    params.require(:ereport).permit(:symbol, :date, :before_or_after_hour, :stock_id)
	  end

	  def option_chains_params
	  	params.require(:option_chain).permit(:symbol, :stock_id, :expiration_date, :option_chains)
	  end
end
