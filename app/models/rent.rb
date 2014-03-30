class Rent < Input

	def build_input (input_data)
		self[:comission_per]  = '30'
		self[:amount] 		  = Rent.obtain_cash(input_data[:amount].to_i, self[:comission_per].to_i)
		self.article  		  = Article.find input_data[:article]
		self[:comission_cash] = self[:amount]
	end

	def self.obtain_cash(amount, percent)
		return ((amount * percent/100) + (amount * percent/100 * 0.22)).round 
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
		  return "Anulación"    
		else
		  puts "Tipo no reconocido"
		end
	end
end