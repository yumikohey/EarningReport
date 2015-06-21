class LandingController < ApplicationController
  def index
  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: Date.parse('2015-06-19')).paginate(:page => params[:golden_page], :per_page => 10)
  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: Date.parse('2015-06-19')).paginate(:page => params[:death_page], :per_page => 10)
  end
end