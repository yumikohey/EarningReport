ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

class Ereport < ActiveRecord::Base
	belongs_to :stock
	has_one :price_before_er
	has_one :price_on_er
	has_one :price_after_er

	validates :date, uniqueness: {scope: :stock_id}
end
