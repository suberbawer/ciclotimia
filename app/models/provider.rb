class Provider < ActiveRecord::Base
	has_many :articles
	def firstname
  		"#{self.name} #{self.lastname}"
	end

	def get_articles_not_sent
		articles_not_sent = self.articles.where(sent: false)
	end

	def set_inputs(list_inputs)
		instance_variable_set("@custom_input_list", list_inputs.find_all{|input| input.status != 'cancelled' && input.status != 'cancel_input' && !input.article.nil? && input.article.provider.id == self.id})
		instance_variable_get "@custom_input_list"
	end

	def self.filter_providers(search_text)
		if search_text != ''
			return Provider.find(:all, :conditions => ["name like ? or lastname like ? or ci = ?", "%#{search_text}%", "%#{search_text}%", search_text])
		else
			return Provider.all
		end
	end

	def self.filter_provider_articles(search_text, providerId)
		if search_text != ''
			return Article.find(:all, :conditions => ["provider_id = ? and (description like ? or id = ?)", providerId, "%#{search_text}%", search_text])
		else
			return Article.find(:all, :conditions => ["provider_id = ?", providerId])
		end
	end
end
