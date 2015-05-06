class Ereport < ActiveRecord::Base
	belongs_to :stock
	has_one :price_before_er
	has_one :price_on_er
	has_one :price_after_er
end
