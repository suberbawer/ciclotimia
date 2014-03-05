class ReportsController < ApplicationController
  	
  	def index
  		@transactions = []
      @outputs_transactions = []
  		if request.post?
   	 		@transactions         = Report.reports_between_dates(params[:start_date], params[:end_date]);
        @outputs_transactions = Report.reports_outputs_between_dates(params[:start_date], params[:end_date]);
   	 		@total_amount         = Report.total_amount(@transactions)
        @total_output_amount  = Report.total_output_amount(@outputs_transactions)
        @total_liquid_amount  = Report.total_liquid(@transactions)
        @total_general_liquid = @total_liquid_amount.to_i + @total_output_amount.to_i
        @total_general        = @total_amount.to_i + @total_output_amount
   	 	end
   	 	if(@transactions.length > 0)
   	 		render :index
   	 	end
  	end
end  	