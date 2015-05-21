class PriceOnEr < ActiveRecord::Base
	belongs_to :ereport
	belongs_to :stock
	serialize :quote, Array

	validates :quote, presence: true
	validates :ereport_id, uniqueness: true
end