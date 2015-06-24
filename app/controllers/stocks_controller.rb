class StocksController < ApplicationController
	include EreportsHelper
	include StocksHelper

	def index
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
	 	redict_to 'index'
 end

  def show
  	require 'yahoo_stock'
  	stock_symbol = params[:symbol].upcase
		stock = Stock.find_by(symbol:stock_symbol)
		@stock_id = stock.id
		@stock = stock.symbol
		@all_ers = stock.ereports.order('date DESC')
		p @all_ers.first
		@all_ers.each do |earning|
			EreportsHelper.earning_report_dates_data(stock.symbol, earning)
		end			
		@all_reports = stock.ereports.order('date DESC')
		quote = YahooStock::Quote.new(:stock_symbols => [@stock])
	 	@current_price = quote.results(:to_array).output
	 	@five_ten = BetaQuote.where(stock_id: stock.id).where("date >= ?", Date.parse('2015-06-23') - 8).order('date DESC')
	 	@company = stock.name
		render :layout => "sub_layout"
	end

	def report_data		
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key = ENV['CONSUMER_KEY']
		  config.consumer_secret = ENV['CONSUMER_SECRET']
		  config.access_token = ENV['ACCESS_TOKEN']
		  config.access_token_secret = ENV['ACCESS_SECRET']
		end
			client.update("I'm tweeting with @gem! '#'#{stock.symbol}")
	end

	def ajax_table
		@stock_symbol = params[:symbol].upcase
		stock = Stock.find_by(symbol:@stock_symbol)
		@all_ers = stock.ereports.order('date DESC')
		p @all_ers.first
		@all_ers.each do |earning|
			EreportsHelper.earning_report_dates_data(@stock_symbol, earning)
		end			
		@all_reports = stock.ereports.order('date DESC').first(3)
	end


	def options
		symbol = params[:symbol]
		url = "http://www.google.com/finance/option_chain?q=#{symbol}&output=json"
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
		OptionChain.create!(symbol:stock_symbol, stock_id:stock_id, expiration_date:expiry, option_chains:option_chains)
    @option_chain = OptionChain.where(stock_id:stock_id, expiration_date:expiry)[0].option_chains
		render 'option'
	end

	def current_pain
		render 'option'
	end

	def golden
		@golden_cross_stocks = BetaQuote.where(cross:1).where(date: Date.parse('2015-06-22')).paginate(:page => params[:golden_page], :per_page => 20)
		render :layout => 'sub_layout'
	end

	def death
		@death_cross_stocks = BetaQuote.where(cross:-1).where(date: Date.parse('2015-06-22')).paginate(:page => params[:death_page], :per_page => 20)
		render :layout => 'sub_layout'
	end
	private
	  def ereports_params
	    params.require(:ereport).permit(:symbol, :date, :before_or_after_hour, :stock_id)
	  end

	  def option_chains_params
	  	params.require(:option_chain).permit(:symbol, :stock_id, :expiration_date, :option_chains)
	  end
end
