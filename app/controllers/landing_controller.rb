class LandingController < ApplicationController
  def index
  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: Date.parse('2015-06-19')).first(10)
  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: Date.parse('2015-06-19')).first(10)
  end
end