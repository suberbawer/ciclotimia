class BillingsController < ApplicationController

	def index
		@providers_to_print = set_list_to_print
	end

	def own_facturation
		@providers_to_print = set_list_to_print
	end

	def provider_month_total
		@providers_to_print = set_list_to_print
	end

	def rent_facturation
		@rents_to_print = set_list_of_rents_to_print
	end

	def send_billing_monthly
		@providers_to_print = set_list_to_print
		@providers_to_print.each do |provider|
			UserMailer.send_billing_monthly(provider).deliver
		end
		redirect_to action: :index
	end
	
	def set_list_to_print
		list_ids_of_providers  = Set.new
		list_inputs_this_month = Input.obtain_current_month_inputs

		# create set of provider ids related with the inputs to show
		list_inputs_this_month.each do |input|
			if (input.article)
				list_ids_of_providers.add(input.article.provider)
			end
		end
		
		@providers_to_print    = Provider.where("id in (?)", list_ids_of_providers);
		Billing.print_providers(@providers_to_print, list_inputs_this_month)
		return @providers_to_print
	end

	def set_list_of_rents_to_print
		list_rents_this_month = Input.obtain_current_month_rents_inputs
	end

end
