class DailyOptionChainJob < ActiveJob::Base
	include Sidekiq::Worker

	queue_as :default 

  def perform(symbol)
  	p "****************"
  	p symbol
  	p "****************"
  end
end
