class Ereport < ActiveRecord::Base
	belongs_to :stock
	has_many :prices
end
