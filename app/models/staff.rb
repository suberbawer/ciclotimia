class Staff < ActiveRecord::Base
	belongs_to :productora
	has_many   :input
	
	# Devuelve los artículos alquilados por el vestuarista
	def get_staff_articles
		staff_articles = Array.new
		self.input.each do |input|
			if !input.article.nil? && input.article.status == 'rented'
				staff_articles.push(input.article)
			end
		end
		return staff_articles
	end
end
