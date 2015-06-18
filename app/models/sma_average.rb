ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

class SmaAverage < ActiveRecord::Base
	belongs_to :stock
end
