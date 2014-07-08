class Staff < ActiveRecord::Base
	belongs_to :productora
	has_many   :input
	
	# Devuelve los articulos alquilados por el vestuarista
	def get_staff_articles
		staff_articles = Array.new
		self.input.each do |input|
			if !input.article.nil?
				staff_articles.push(input.article)
			end
		end
		return staff_articles
	end
end
