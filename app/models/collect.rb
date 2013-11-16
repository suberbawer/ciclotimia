class Collect < Caja

	#validate :start_date_not_open_collect_present

	# Abre una caja y la devuelve, o nil si ya hay una caja abierta.
	def self.open_caja
		if self.is_any_open_caja
			current_collect = nil
		else
			current_collect = Collect.create(:status => 'open', :start_Date => DateTime.now, :end_date   => DateTime.now)
		end	
		puts current_collect
	end

	# Devuelve true si hay una o mas cajas abiertas en cualquier fecha, falso de otra manera.
	# esto mismo hacerlo con una validacion.
	def self.is_any_open_caja
		return Collect.where(:type => 'Collect', :status => 'open').length >= 1
	end

	# Obtiene la caja abierta de hoy.
	def self.get_open_caja
		return Collect.where(:type => 'Collect', :status => 'open', :start_Date => DateTime.now.beginning_of_day..DateTime.now.end_of_day)[0]
	end

	def self.reason_not_current_open
		reason = "No hay error con la caja"
		if !self.is_any_open_caja
			reason = "No hay una caja abierta" 
		elsif !self.get_open_caja.present?
			reason = "La caja abierta no es del dia de hoy, cierrela e intente de nuevo"
		end	
	end
end