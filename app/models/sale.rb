class Sale < Input

	def build_input (input_data)
		self[:amount] = input_data[:amount]
		self.article  = Article.find input_data[:article]
	end

	def obtain_human_label
		return self.retrieve_label(self.type || self.status)
	end

	def retrieve_label(type)
		case type
		when "sale", "Sale"
		  return "Venta" 
		when "rent", "Rent"
		  return "Alquiler"
		when "Output"
		  return "Egreso"
		when "cancel_input"
		  return "Anulacion"    
		else
		  puts "Tipo no reconocido"
		end
	end

end