class StaticPagesController < ApplicationController
	def index
		render 'index', layout: false
	end

	def search
	end

end
