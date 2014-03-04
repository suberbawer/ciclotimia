class BillingsController < ApplicationController

def index
	list_inputs_this_month = Input.obtain_current_month_inputs
	@providers_to_print    = Provider.where("id in (?)", list_inputs_this_month.map(&:id));
	Billing.print_providers(@providers_to_print, list_inputs_this_month)
end

end
