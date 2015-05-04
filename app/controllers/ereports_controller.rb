class EreportsController < ApplicationController
	def create
		require 'open-uri'
		search_result = Stock.where(symbol:params[:symbol])

		if search_result.empty?
			@stock = Stock.new(symbol:params[:symbol])
			@stock.save
			p "stock stored in db, where stock_id = #{@stock.id}"
			qrt = [1,2,3,4]
			year = [2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015]
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
			render 'stocks/show'
		else
			@stock = search_result[0].ereports.first.symbol
			@all_ers = search_result[0].ereports
			@html = []
			@all_ers.each do |earning|
				if earning.date <= Date.today
					formatted_date = earning.date.strftime("%m/%d/%Y").to_s.split("/")
					month = formatted_date[0].to_i
					date = formatted_date[1].to_i
					year = formatted_date[2].to_i
					url = "http://finance.yahoo.com/q/hp?s=#{params[:symbol]}&a=#{month-1}&b=#{date-1}&c=#{year}&d=#{month-1}&e=#{date+1}&f=#{year}&g=d"
					page = Nokogiri::HTML(open(url))
					page.search('.yfnc_datamodoutline1').map do |element|
						@html.push(element.inner_html)
					end
				else
					p earning.date
				end
			end
			render 'index'
		end
	end

	private
	  def ereports_params
	    params.require(:ereport).permit(:symbol, :date, :before_or_after_hour, :price_before_er, :price_after_er, :price_on_er, :stock_id)
	  end
end
