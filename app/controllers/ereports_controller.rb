class EreportsController < ApplicationController
	include EreportsHelper
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
			render 'stocks/show'
		else
			@stock = params[:symbol]
			stock_symbol = @stock
			@stock_info = Stock.where(symbol:params[:symbol])[0]
			all_reports = @stock_info.ereports
			all_reports.each do |report|
				if (report.date <= Date.today && !report.price_before_er)
					EreportsHelper.earning_report_dates_data(stock_symbol, report)
				end
			end
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
