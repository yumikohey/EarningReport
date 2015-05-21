class OptionChain < ActiveRecord::Base
	belongs_to :stock
	serialize :option_chains, JSON
end