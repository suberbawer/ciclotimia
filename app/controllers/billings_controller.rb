class BillingsController < ApplicationController

	def index
		@providers_to_print = set_list_to_print
	end

	def own_facturation
		@providers_to_print = set_list_to_print
	end

	def send_billing_monthly
		@providers_to_print = set_list_to_print
		@providers_to_print.each do |provider|
			UserMailer.send_billing_monthly(provider).deliver
		end
		redirect_to action: :index
	end
	
	def set_list_to_print
		list_inputs_this_month = Input.obtain_current_month_inputs
		@providers_to_print    = Provider.where("id in (?)", list_inputs_this_month.map(&:id));
		Billing.print_providers(@providers_to_print, list_inputs_this_month)
		return @providers_to_print
	end

end
