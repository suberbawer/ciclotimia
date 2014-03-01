class BillingsController < ApplicationController

def index
	@billings = Billing.all;
end

end
