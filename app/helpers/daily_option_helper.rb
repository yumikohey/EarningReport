module DailyOptionHelper
	def self.option_chains
			stock_list = Stock.all
			date_unix = DateTime.parse("2015-08-06 17:00:00 -0700").to_time.to_i
			stock_list.each do |stock|
					url = "http://finance.yahoo.com/q/op?s=#{stock.symbol}&straddle=true&date=#{date_unix}"
					puts url
					begin
						doc = Nokogiri::HTML(open(url))
					rescue
						p "404 page"
					else
						table = doc.css("div.quote-table-overflow td.straddle-strike")
						option_chain = []
						table.each do |strike_price|
							strike_hash = Hash.new
							call_oi = strike_price.previous_element.text
							put_oi = strike_price.next_element.next_element.next_element.next_element.next_element.text
							strike_hash["call_oi"] = call_oi.to_i
							strike_hash["strike_price"] = strike_price.text.to_f
							strike_hash["put_oi"] = put_oi.to_i
							option_chain.push(strike_hash)
						end
						p option_chain.length
						if (option_chain.length > 1)
							DailyOption.create!(symbol:stock.symbol, expiration_date:Date.parse("2015-08-06 17:00:00 -0700").next, option_chains:option_chain, record_date: Date.today - 1)
						end
					end
				end
	end
end
