module EarningCalendarsHelper
		require 'csv'
		def self.import(filename=File.expand_path(".")+ "/db/data/earning.csv")
	    field_names = nil
	    EarningCalendar.transaction do
	      File.open(filename).each do |line|
	        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	        valid_line = ic.iconv(line)
	        data = valid_line.chomp.split(',')
	        
	        if field_names.nil?
	          field_names = data
	        else
	          attribute_hash = Hash[field_names.zip(data)]
	          # business = Business.create!(attribute_hash)
	          attribute_hash["day"] = "#{attribute_hash["day"]}, 2015"
	          stock_symbol = attribute_hash["symbol"]
	          this_stock = Stock.where(symbol:stock_symbol)[0]
	          if this_stock
	          	attribute_hash["stock_id"] = this_stock.id
	          	p "********************************"
	          end
	          if !stock_symbol.match(/\d/)
	         		EarningCalendar.create!(attribute_hash)
	          else
	        		p "not a US stock"
	        	end
	        end
	      end
	    end
	  end
end
