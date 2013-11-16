class Caja < ActiveRecord::Base
	has_many :caja_transactions
	has_many :inputs, :through => :caja_transactions, :source => :transaction, :source_type => 'Input'
	has_many :outputs, :through => :caja_transactions, :source => :transaction, :source_type => 'Output'

	#scope :current_open, -> { where(:type => '')}

	#scope :currently_open, where(:type => 'Collect', :status => 'open')

end
