class Staff < ActiveRecord::Base
	belongs_to :productora
	has_many   :input
end
