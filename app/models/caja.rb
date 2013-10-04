class Caja < ActiveRecord::Base
	has_many :caja_transactions
	has_many :input, :through => :caja_transactions, :source => :transaction, :source_type => 'Input'
	has_many :output, :through => :caja_transactions, :source => :transaction, :source_type => 'Output'
end
