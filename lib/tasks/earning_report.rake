desc "download one week's earning report date"

task earning_report: :environment do
	#today = Time.zone.today
	today = Date.parse('2015-06-23')
	days = (0..30).to_a
	days.each do |day|
			date = today + day 
			date_str = date.to_s.split("-").join("")
			url = "http://biz.yahoo.com/research/earncal/#{date_str}.html"
			p url
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
						Ereport.create!(symbol:key, date:date, stock_id:stock.id)
						array.push(key)
					end
				end
			end
	end
end