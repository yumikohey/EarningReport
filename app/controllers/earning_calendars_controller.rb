class EarningCalendarsController < ApplicationController
	include EarningCalendarsHelper
	def month_er
		EarningCalendarsHelper.import
		render 'index'
	end
end
