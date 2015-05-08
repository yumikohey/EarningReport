module EarningCalendarsHelper
		require 'csv'
		def self.import(filename=File.expand_path(".")+ "/db/data/businesses_plus.csv")
	    field_names = nil
	    Business.transaction do
	      File.open(filename).each do |line|
	        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
	        valid_line = ic.iconv(line)
	        data = valid_line.chomp.split(',')
	        data.each_with_index do |x, idx|
	          if x.start_with?(" ")
	            data[idx-1] = data[idx-1] + x
	            data.delete(x)
	          end
	        end
	        data.each do |string|
	          if string =~ /\d{10,}/
	            string
	          else
	            string.gsub!(/["]/,"")
	          end
	        end
	        
	        if field_names.nil?
	          field_names = data
	        else
	          attribute_hash = Hash[field_names.zip(data)]
	          business = Business.create!(attribute_hash)
	        end
	      end
	    end
	  end
end
