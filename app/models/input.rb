class Input < ActiveRecord::Base
	has_one :caja_transaction, :as =>:transaction
	has_one :caja, :through => :caja_transactions
	has_one :article
	accepts_nested_attributes_for :article

	def polymorphic_method
		raise "Not working for #{self.class}"
	end

	# 
	# Method in charge of create and insert an input.
	#
	# * *Args*    :
	#   - +input_data+ -> data of the input to save
	# * *Returns* :
	#   - true if the input was saved, false otherwise
	#
	def self.insert_input(input_data)
		case input_data[:type]
		when "sale"
		  input = Sale.new 
		when "rent"
		  input = Rent.new
		else
		  puts "nono"
		end
		input[:amount] = input_data[:amount]
		return input.save
	end

	def c_new_input
		puts 'hello world'
	end
end
