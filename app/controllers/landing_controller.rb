class LandingController < ApplicationController
  def index
  	@golden_cross_stocks = BetaQuote.where(cross:1).where(date: Date.parse('2015-06-19')).paginate(:page => params[:page], :per_page => 20)
  	@death_cross_stocks = BetaQuote.where(cross:-1).where(date: Date.parse('2015-06-19')).paginate(:page => params[:page], :per_page => 20)
  end
end