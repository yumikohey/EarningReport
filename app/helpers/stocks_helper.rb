module StocksHelper
	# def self.read_yahoo_data
	# 	tomorrow_str = Time.zone.today.next_day.to_s.split("-").join("")
	# 	url = "http://biz.yahoo.com/research/earncal/#{tomorrow_str}.html"
	# 	page = Nokogiri::HTML(open(url))
	# 	page.search('.date').map do |element|
	# 		temp = (element.inner_text[0..-5]).split('/')
	# 		date_str = (temp[1] +'/'+ temp[0] +'/20'+ temp[2]).to_s
	# 		earning_report = Ereport.create(symbol:stock_symbol, date:date_str, stock_id:stock_id)
	# 		p earning_report.stock_id
	# 	end	
	# end
end
