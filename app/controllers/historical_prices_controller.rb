class HistoricalPricesController < ApplicationController

	def index
		@stock = Stock.find_by(symbol: 'AAPL')
  	@quotes = HistoryQuote.where(stock_id:@stock.id)
	end
	
	def next
		@stock = Stock.find(7160)
  	@quote = HistoryQuote.where(stock_id:@stock.id).first
  	respond_to do |format|
  		#format.html { redirect_to history_index_path }
  		format.js
  	end
	end	

end
