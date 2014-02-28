class Collect < Caja
	include ActiveModel::Validations

	#Refactorizar toda la clase!!!!

	validate :only_one_open_caja , on: :create
	#validate :start_date_not_open_collect_present



	# Metodos de clase.

	# Abre una caja y la devuelve, o nil si ya hay una caja abierta.
	def self.open_caja
		begin
		  	Collect.create!(:status => 'open', :start_Date => DateTime.now, :end_date => DateTime.now)
			current_message = 'La caja se abrió correctamente'
		rescue ActiveRecord::RecordInvalid => e
		  	current_message = e.message
		end
	end

	# Cierra la caja actual , si no hay caja actual devuelve nil (no probado, testear).
	def self.close_today_caja
		if self.is_any_open_caja_today
			current_collect 	   = self.get_open_caja['record']
			current_collect.status = 'closed'
			current_collect.save
		else
			current_collect = nil
		end
	end

	# Cierra una caja de cualquier dia.
	def self.close_previous_caja
		if self.is_any_open_caja && !self.is_any_open_caja_today
			current_collect = Collect.where(:status => 'open')[0]
			current_collect.status = 'closed'
			current_collect.save
		else
			current_collect = nil
		end
	end

	# Devuelve true si hay una caja abierta en cualquier fecha, falso de otra manera.
	# esto mismo hacerlo con una validacion.
	def self.is_any_open_caja
		Collect.where(:status => 'open').length >= 1
	end

	# Devuelve true si hay una caja abierta de hoy, falso de otra manera.
	def self.is_any_open_caja_today
		Collect.where(:status => 'open', :start_Date => DateTime.now.beginning_of_day..DateTime.now.end_of_day).length >= 1
	end

	# Obtiene un json con el mensaje (ok, o error con su mensaje correspondiente) y la caja abierta de hoy (si no hay error).
	def self.get_open_caja
		current_open  = Collect.where(:status => 'open', :start_Date => DateTime.now.beginning_of_day..DateTime.now.end_of_day)[0]
		if !current_open.nil?
			json_response = {'result' => 'ok', 'record' => current_open}
		else
			json_response = {'result' => self.error_not_open,'message' => self.reason_not_current_open}
		end
	end

	def	self.get_today_cajas
		Collect.where(:start_Date => DateTime.now.beginning_of_day..DateTime.now.end_of_day)
	end

	# Obtiene las cajas de hoy
	def self.get_today_transactions
		today_cajas   = self.get_today_cajas
		today_inputs  = []
		today_outputs = []
		today_cajas.each do |today_caja|
			puts today_caja.inputs
		   today_inputs.concat( today_caja.inputs )
		   today_outputs.concat( today_caja.outputs ) 
		end
		return today_inputs.concat( today_outputs )
		# despues concatenar los inputs con los outputs [ "a", "b" ].concat( ["c", "d"] ) 
	end

	# Obtiene la razon por la cual no hay caja abierta (esto hacerlo con validaciones).
	def self.reason_not_current_open
		reason = "No hay error con la caja"
		if !self.is_any_open_caja
			reason = "No hay una caja abierta" 
		elsif !self.is_any_open_caja_today
			reason = "La caja abierta no es del dia de hoy, cierrela e intente de nuevo"
		end	
	end

	# Obtiene la razon por la cual no hay caja abierta (solo la constante, si, hay que refactorizar).
	def self.error_not_open
		reason = "ok"
		if !self.is_any_open_caja
			reason = "no_open" 
		elsif !self.is_any_open_caja_today
			reason = "open_before"
		end	
	end

	# Metodo encargado de cancelar el input dado por parametro (se crea un nuevo input identico al anterior
	# pero con amount opuesto y se inserta en la caja actual
    # Devuelve ok si todo se ejecuto con exito, constantes si se reconoce el error, o el error si no lo reconoce.
	# REFACTORIZAR
	def self.cancel_transaction (input_id)
		message_cancelled = "ok"
		input_to_cancel   = Input.find(input_id)
		cancel_input      = input_to_cancel.create_cancel_input
		
		open_caja_response = Collect.get_open_caja
		if open_caja_response['result'] == 'ok' && !input_to_cancel.nil? && !cancel_input.nil? 
			begin
			  	current_open = open_caja_response['record']
				current_open.caja_transactions.create!(:transaction => cancel_input) # Agrego la anulacion a la open_caja
			rescue ActiveRecord::RecordInvalid => e
			  	message_cancelled = e.message
			end
		else
			if open_caja_response['result'] != 'ok'
				message_cancelled = "not_open_caja"	
			elsif input_to_cancel.nil?
				message_cancelled = "input_to_cancel_error"
			elsif cancel_input.nil?
				message_cancelled = "cancel_input_error"
			end			
		end
		return message_cancelled
	end



	# Metodos de instancia.

	# Cierra self.
	def close
		self.status = 'closed'
		self.save
	end

	# Abre self
	def open
		#return
	end


	# Validaciones

	# Se asegura que solo una caja collect este abierta a la vez.
	def only_one_open_caja
		errors.add(:base, 'Ya hay una caja abierta') if Collect.is_any_open_caja
	end
end