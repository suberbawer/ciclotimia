class Billing < ActiveRecord::Base
	has_many :inputs
	has_one :provider

	def self.print_providers(list_providers, list_inputs)
		list_providers.each do |provider|
			provider.set_inputs(list_inputs)
		end
	end	
end