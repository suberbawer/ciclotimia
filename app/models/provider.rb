class Provider < ActiveRecord::Base
	has_many :articles

	def get_not_sent
		articles_not_sent = self.articles.where(sent: false)
	end
end
