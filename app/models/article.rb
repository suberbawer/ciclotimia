class Article < ActiveRecord::Base
	belongs_to :transaction
	belongs_to :input

	# Devuelve true si el articulo tiene un input asociado, de otra forma false.
	def has_input
		# Mientras tenga input_id no se puede usar (se vendio, o esta siendo alquilada ahora,
		# cuando se devuelve el articulo se dessetea el input_id).
	end

	def set_status(input_status)
		new_status = ""
		case input_status
		when "Sale"
			new_status = "sold"  
		when "Rent"
		  	new_status = "rented"
		when "OtherInput"
		  	new_status = ""
		else
		  	new_status = ""
		end
		self.status = new_status
		self.save
	end

	def return_article
		if self.status == "rented"
			self.status = ""
			return self.save
		end
		return false	
	end
end
