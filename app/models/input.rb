class Input < ActiveRecord::Base

	has_one :caja_transaction, :as =>:transaction
	has_one :caja, :through => :caja_transactions
	has_one :article
	accepts_nested_attributes_for :article

	validate :correctly_update_status , on: :update

	#scope :anteriores, lambda { where('created_at < = ?', Time.now) } named_scope
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
		  return nil
		end
		input.build_input(input_data)
		if input_data[:article]
			related_article = Article.find input_data[:article]
			if related_article
				related_article.set_status(input.type)
			end
		end
		return input
	end

	# 
	#   Metodo encargado de salvar la lista de inputs en la caja abierta de hoy (si hay)
	#
	# * *Args*    :
	#   - +input_list+ -> Lista con los inputs a ingresar.
	#                     :type, [:amount], [:article] 
	# * *Returns* :
	#   - json con los datos necesarios dependiendo si salvo, o si tuvo algun error.
	#
	def self.save_inputs (input_list)
		json_response = Collect.get_open_caja
		if json_response['result'] == 'ok'
			current_open = json_response['record']
			input_list.each do |input|
		    	new_input = self.build_input(input[1])
		    	current_open.caja_transactions.create!(:transaction => new_input) # Agrego a la lista de inputs de la open_caja
		   		# TODO Si hay algun error aca, agregarlo a json_response
		   	end
		   	json_response['message'] = "Las transacciones se insertaron correctamente" # TODO aca tengo que ver si se salvaron los inputs correctamente.
		end
		return json_response
	end

	def self.save_single_input (input_data)
		json_response = Collect.get_open_caja
		if json_response['result'] == 'ok'
			current_open = json_response['record']
			new_input = self.build_input(input_data)
		    current_open.caja_transactions.create!(:transaction => new_input)
		end
		return new_input
	end


	# Metodos de instancia

	# Crea una copia de this (con amount inverso) y lo devuelve. 
	def create_cancel_input
		cancel_input           = Input.new
		cancel_input.amount    = self.amount * -1
		cancel_input.cancel_id = self.id
		cancel_input.status    = "cancel_input"

		self.status            = "cancelled"
		self.article.status    = ""		# El articulo ya no esta ni vendido ni alquilado
		self.save
		return cancel_input
	end

	# Valida los posibles cambios de estado del input (por ejemplo no se puede cancelar un input ya cancelado, etc).
	def correctly_update_status
		errors.add(:base, 'La transaccion no fue exitosa') if self.invalid_status
	end

	# True si el cambio de status es no correcto, false de otra manera.
	def invalid_status
		invalid = false
		if self.status_changed?
			invalid = self.status_was != "active"
		end
	end
end