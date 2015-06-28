class LandingController < ApplicationController
  def index
  	@today = BetaQuote.last.date
  	if BetaQuote.where(date:@today).where(cross:1).count > 0
	  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: @today).first(10)
	  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: @today).first(10)
	  else
	  	while (BetaQuote.where(date:@today).where(cross:1).count <= 0) do
	  		@today -= 1
		  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: @today).first(10)
		  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: @today).first(10)
		  end
	  end
  end
end