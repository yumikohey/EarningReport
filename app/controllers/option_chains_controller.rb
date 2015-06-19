class OptionChainsController < ApplicationController
	def current_pain
		constant_number = 20
		symbol = params[:symbol]
		stock = DailyOption.where(symbol:symbol, expiration_date:Date.parse('2015-06-19')).first
		option_chains = stock.option_chains
		strike_price_array = []
		calls = []
		puts = []
		call_volumes = []
		put_volumes = []
		option_chains.each do |strike_price_level|
			calls.push(strike_price_level["call_oi"])
			puts.push(strike_price_level["put_oi"])
			strike_price_array.push(strike_price_level["strike_price"])
		end

		close_prices = []
		close_price_start = strike_price_array.first.round(2)

		while (close_price_start <= strike_price_array.last) do
			close_price_start += 0.10
			close_prices.push(close_price_start.round(2))
		end

		close_prices.each do |target_price|
			call_sum = 0
			strike_price_array.each_with_index do |strike_price, idx|
				if ( target_price > strike_price)
					call_sum += (target_price - strike_price) * calls[idx]
				end
			end
			call_volumes.push(call_sum)
		end 

		close_prices.each do |target_price|
			put_sum = 0
			strike_price_array.each_with_index do |strike_price, idx|
				if(strike_price > target_price)
					put_sum += (strike_price - target_price) * puts[idx]
				end
			end
			put_volumes.push(put_sum)	
		end 

		@current_pain_array = []
		close_prices.each_with_index do |ele, idx|
			@current_pain_array.push(call_volumes[idx] + put_volumes[idx])
		end
		@current_pain = @current_pain_array.min
		@current_pain_idx = @current_pain_array.index(@current_pain)


		gon.strike_price_array = close_prices[@current_pain_idx-constant_number..@current_pain_idx+constant_number]
		gon.call_volumes = call_volumes[@current_pain_idx-constant_number..@current_pain_idx+constant_number]
		gon.put_volumes = put_volumes[@current_pain_idx-constant_number..@current_pain_idx+constant_number]


		respond_to do |format|
			format.html { render :layout => "empty" }
		end
	end
end
