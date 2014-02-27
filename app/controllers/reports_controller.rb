class ReportsController < ApplicationController
  	
  	def index
  		@transactions = []
  		if request.post?
   	 		@transactions = Report.reports_between_dates(params[:start_date], params[:end_date]);
   	 		render :index
   	 	end
  	end

end  	