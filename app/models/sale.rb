class Sale < Input

	def build_input (input_data)
		self[:amount]         = input_data[:amount]
		self.article          = Article.find input_data[:article]
		self[:comission_per]  = self.article['commission_per']
		self[:comission_cash] = Sale.obtain_cash(self[:amount].to_i, self[:comission_per].to_i)
		self[:article_desc]   = article.description
        self[:article_id]     = article.id
	end

	def self.obtain_cash(amount, percent)
		return ((amount * percent.to_f/100) + (amount * percent.to_f/100 * 0.22)).round 
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