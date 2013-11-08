class Input < ActiveRecord::Base
	has_one :caja_transaction, :as =>:transaction
	has_one :caja, :through => :caja_transactions
	has_one :article
	accepts_nested_attributes_for :article

	#scope :anteriores, lambda { where('created_at < = ?', Time.now) }
	#scope :anteriores, ->(id) { where(:created_at => id)}

	# 
	# Method in charge of create and insert an input.
	#
	# * *Args*    :
	#   - +input_data+ -> data of the input to save
	#                     :type, [:amount], [:article] 
	# * *Returns* :
	#   - true if the input was saved, false otherwise
	#
	def self.build_input(input_data)
		case input_data[:type]
		when "sale"
		  input = Sale.new
		when "rent"
		  input = Rent.new
		when "other_input"
		  input = OtherInput.new
		else
		  puts "Tipo de input no reconocido"
		end
		input.build_input(input_data)
		return input
	end
end
