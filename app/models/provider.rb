class Provider < ActiveRecord::Base
	has_many :articles

	def get_articles_not_sent
		articles_not_sent = self.articles.where(sent: false)
	end

	def set_inputs(list_inputs)
		instance_variable_set("@custom_input_list", list_inputs.find_all{|input| input.status != 'cancelled' && input.status != 'cancel_input' && input.article.provider.id == self.id})
		instance_variable_get "@custom_input_list"
	end

	def self.filter_providers(search_text)
		if search_text != ''
			return Provider.find(:all, :conditions => ["name like ? or lastname like ? or ci = ?", "%#{search_text}%", "%#{search_text}%", search_text])
		else
			return Provider.all
		end
	end
end
