class OtherInput < Input

	def build_input (input_data)
		self[:amount]  		  = input_data[:amount]
		self[:comission_per]  = 100
		self[:concept] 		  = input_data[:concept]
		self[:article_desc]   = input_data[:article_desc]
        self[:article_id]     = input_data[:article_id]
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
		when "OtherInput"
		  return "Ingreso manual"  
		when "Output"
		  return "Egreso"
		when "cancel_input"
		  return "Anulación"    
		else
		  puts "Tipo no reconocido"
		end
	end
end