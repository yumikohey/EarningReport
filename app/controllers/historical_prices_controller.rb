class HistoricalPricesController < ApplicationController

	def index
		@stock = Stock.find_by(symbol: 'AAPL')
  	@quotes = HistoryQuote.where(stock_id:@stock.id)
	end
	
	def next
		@stock = Stock.find(7160)
  	@quote = HistoryQuote.where(stock_id:@stock.id).first
  	render "index"
	end	

end
