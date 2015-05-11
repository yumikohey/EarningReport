class PutCallRatiosController < ApplicationController
		def index
			render 'index'
		end

		def data
			@pcratios = PutCallRatio.all
			render json: @pcratios
		end

		def create
			if !Stock.where(symbol:params[:put_call_ratio][:symbol]).empty?
				p stock_id = Stock.where(symbol:params[:put_call_ratio][:symbol])[0].id
			end
			params[:put_call_ratio][:stock_id] = stock_id
			params[:put_call_ratio][:pcratio] = params[:put_call_ratio][:pcratio].to_f
			PutCallRatio.create!(pcratio_params)
			redirect_to put_call_ratios_download_pcratio_path
		end

		def download_pcratio
			@stock = PutCallRatio.new
			# stocks = Stock.first(10)
			# attribute_hash = Hash.new()
			# stocks.each do |stock|
			# 	attribute_hash["symbol"] = stock.symbol
			# 	attribute_hash["stock_id"] = stock.id
			# 	url = "https://www.stockoptionschannel.com/symbol/?symbol=#{stock.symbol}&confirm=1"
			# 	page = Nokogiri::HTML(open(url))
			# 	#p ratio = page.at('div:contains("Put:Call Ratio:")').text
			# 	ratio_str = page.at('i:contains("Put:Call Ratio:")').text.strip
			# 	ratio_array = ratio_str.split(" ")
			# 	attribute_hash["pcratio"] = ratio_array[-1]
			# 	put_call_volumes = []
			# 	ratio_array.each do |part|
			# 		if part.match(/\d/)
			# 			volume = part.match(/\d{1,},\d{1,}/).to_s.split(",").join("").to_i
			# 			put_call_volumes.push(volume)
			# 		end
			# 	end
			# 	attribute_hash["calls"] = put_call_volumes[1]
			# 	attribute_hash["puts"] = put_call_volumes[0]
			# 	PutCallRatio.create!(attribute_hash)
			# end
			render 'text'
		end

		private
		  def pcratio_params
		    params.require(:put_call_ratio).permit(:symbol, :date, :calls, :puts, :total, :pcratio, :stock_id)
		  end
end
