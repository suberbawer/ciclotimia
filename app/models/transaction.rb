class Transaction < ActiveRecord::Base
	has_many :caja_transactions
end
