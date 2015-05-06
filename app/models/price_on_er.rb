class PriceOnEr < ActiveRecord::Base
	belongs_to :ereport
	belongs_to :stock
	serialize :quote, Array
end