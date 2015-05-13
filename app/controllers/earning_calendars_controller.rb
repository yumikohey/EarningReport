class EarningCalendarsController < ApplicationController
	include EarningCalendarsHelper
	def month_er
		EarningCalendarsHelper.import
		render 'index'
	end

	def index
		@stocks = EarningCalendar.where(day:Date.today.next_day)
		render 'index'
	end
end
