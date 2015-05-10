class PutCallRatiosController < ApplicationController
		def index
			render 'index'
		end

		def data
			@pcratios = PutCallRatio.all
			render json: @pcratios
		end
end
