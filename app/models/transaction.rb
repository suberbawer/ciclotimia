class Transaction < ActiveRecord::Base
	has_many :caja_transactions
	has_one  :article

end
