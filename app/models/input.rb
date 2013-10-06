class Input < ActiveRecord::Base
	has_one :caja_transaction, :as =>:transaction
	has_one :caja, :through => :caja_transactions
	has_one :article

	def polymorphic_method
		raise "Not working for #{self.class}"
	end
end
