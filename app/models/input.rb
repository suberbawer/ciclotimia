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
	def self.build_input (input_data)
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

	# 
	#   Metodo encargado de salvar la lista de inputs en la caja abierta de hoy (si hay)
	#
	# * *Args*    :
	#   - +input_list+ -> Lista con los inputs a ingresar.
	#                     :type, [:amount], [:article] 
	# * *Returns* :
	#   - Mensaje dependiendo si salvo, o si tuvo algun error.
	#
	def self.save_inputs (input_list)
		current_open = Collect.get_open_caja
		if current_open.present?
			input_list.each do |input|
		    	new_input = self.build_input(input[1])
		    	#new_input.save
		    	current_open.caja_transactions.create(:transaction => new_input) # Agrego a la lista de inputs de la open_caja
		   	end
		   	#puts current_open.caja_transactions
		   	response_message = "OK"		   	
		else
			response_message = Collect.reason_not_current_open
		end   
	end
end