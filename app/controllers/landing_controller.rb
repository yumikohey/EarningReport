class LandingController < ApplicationController
  def index
  	today = Date.today - 1
  	check = BetaQuote.where(date: today)
  	if check && !today.saturday? && !today.sunday?
	  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: today).first(10)
	  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: today).first(10)
	  elsif !check && !today.saturday? && !today.sunday?
	  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: today - 1).first(10)
	  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: today - 1).first(10)
	  else
	  	today = BetaQuote.last.date
	  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: today - 1).first(10)
	  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: today - 1).first(10)
	  end
  end
end