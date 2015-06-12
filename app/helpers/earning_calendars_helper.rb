module EarningCalendarsHelper
		require 'csv'
		def self.import(filename=File.expand_path(".")+ "/db/data/AllETFs.csv")
			p "hello"
	    field_names = nil
	    EarningCalendar.transaction do
	      File.open(filename).each do |line|
	        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	        valid_line = ic.iconv(line)
	        data = valid_line.chomp.split(',')      
	        if field_names.nil?
	        	p "world"
	          field_names = data
	        else
	          attribute_hash = Hash[field_names.zip(data)]
	          p "im here"
	          Stock.create!(attribute_hash)
          end
        end
      end
    end
end
	          # attribute_hash["day"] = "#{attribute_hash["day"]}, 2015"
	          # stock_symbol = "CBOE"
	          # stock_id = 6688
	          # attribute_hash["symbol"] = stock_symbol
	          # attribute_hash["stock_id"] = stock_id
	          # attribute_hash["date"] = Date.strptime(attribute_hash["date"], '%m/%d/%Y')

	          # PutCallRatio.create!(attribute_hash)
	         #  if this_stock
	         #  	attribute_hash["stock_id"] = this_stock.id
	         #  	p "********************************"
	         #  	EarningCalendar.create!(attribute_hash)
	         #  else
	        	# 	p "not a US stock"
	        	# end

