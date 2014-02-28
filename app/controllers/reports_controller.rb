class ReportsController < ApplicationController
  	
  	def index
  		@transactions = []
  		if request.post?
   	 		@transactions = Report.reports_between_dates(params[:start_date], params[:end_date]);
   	 		@total_amount = Report.total_amount(@transactions);
   	 		render :index
   	 	end
  	end
end  	