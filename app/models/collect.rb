class Collect < Caja
	include ActiveModel::Validations

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

	# Cierra la caja actual, si no hay caja actual devuelve nil (no probado, testear).
	def self.close_today_caja
		if self.is_any_open_caja
			current_collect 	   = self.get_open_caja
			current_collect.status = 'closed'
			current_collect.save
		else
			current_collect = nil
		end
	end

	# Devuelve true si hay una o mas cajas abiertas en cualquier fecha, falso de otra manera.
	# esto mismo hacerlo con una validacion.
	def self.is_any_open_caja
		Collect.where(:status => 'open').length >= 1
	end

	# Obtiene un json con el mensaje (ok, o error con su mensaje correspondiente) y la caja abierta de hoy (si no hay error).
	def self.get_open_caja
		current_open  = Collect.where(:status => 'open', :start_Date => DateTime.now.beginning_of_day..DateTime.now.end_of_day)[0]
		if current_open.present?
			json_response = {'result' => 'ok', 'record' => current_open}
		else
			json_response = {'result' => 'error','message' => self.reason_not_current_open}
		end
	end

	def	self.get_today_cajas
		Collect.where(:start_Date => DateTime.now.beginning_of_day..DateTime.now.end_of_day)
	end

	def self.get_today_transactions
		today_cajas  = self.get_today_cajas
		today_inputs = Array.new
		today_cajas.each do |today_caja|
		   today_inputs.concat( today_caja.inputs ) 
		end
		return today_inputs
		# despues concatenar los inputs con los outputs [ "a", "b" ].concat( ["c", "d"] ) 
	end

	# Obtiene la razon por la cual no hay caja abierta (esto hacerlo con validaciones).
	def self.reason_not_current_open
		reason = "No hay error con la caja"
		if !self.is_any_open_caja
			reason = "No hay una caja abierta" 
		elsif !self.get_open_caja.present?
			reason = "La caja abierta no es del dia de hoy, cierrela e intente de nuevo"
		end	
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