class Article < ActiveRecord::Base
	belongs_to :transaction
	belongs_to :input
end
