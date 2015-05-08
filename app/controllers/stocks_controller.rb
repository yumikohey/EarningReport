class StocksController < ApplicationController
	include EreportsHelper
	include StocksHelper

	def index
		render 'index'
	end

	def create
		require 'open-uri'
		stock_symbol = params[:symbol]
		search_result = Stock.where(symbol:stock_symbol)

		if search_result.empty?
			@stock = Stock.new(symbol:stock_symbol)
			@stock.save
			stock_id = @stock.id
			
			p "stock stored in db, where stock_id = #{@stock.id}"
			qrt = [1,2,3,4]
			year = (2012..Date.today.year).to_a
			year.each do |each_year|
				qrt.each do |each_qrt|
					EreportsHelper.get_earning_report_dates(stock_symbol, stock_id, each_qrt, each_year)
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
				EreportsHelper.earning_report_dates_data(stock_symbol, earning)
			end

			this_stock = Stock.where(symbol:stock_symbol)[0]
			@all_reports = this_stock.ereports
		  redirect_to "/stocks/#{stock_symbol}"
		else
			@stock = params[:symbol]
			stock_symbol = @stock
			@stock_info = Stock.where(symbol:params[:symbol])[0]
			all_reports = @stock_info.ereports
			all_reports.each do |report|
				report_id = report.id
				price_after_er = PriceAfterEr.where(ereport_id:report_id, volume:nil)[0]
				if (report.date <= Date.today && price_after_er)
					p "AWESOME"
					EreportsHelper.earning_report_dates_data(stock_symbol, report)
				end
			end
			@all_reports = @stock_info.ereports
			@no_report = false
			if @all_reports.count == 0
				@no_report = true
			end
			p @no_report
			redirect_to "/stocks/#{stock_symbol}"
		end
	end

	def show
		@stock = params[:symbol]
		stock = Stock.where(symbol:params[:symbol])[0]
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
