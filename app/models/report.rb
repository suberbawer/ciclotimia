class Report < Caja
	include ActiveModel::Validations

	attr_readonly :status
	before_save :set_default

	def set_default
		self.status = "report" unless self.status
	end

	def self.reports_between_dates(start_date, end_date)
		if start_date == 'mes'
			start_date = Date.today.beginning_of_month
			end_date   = Date.today.end_of_month
		elsif start_date == 'diario'
			start_date = Date.today.beginning_of_day
			end_date   = Date.today.end_of_day
		end

		return Input.find(:all, :conditions => ["created_at between ? and ?", start_date, end_date])
		
	end
	#Input.find(:all, :conditions => ["created_at between ? and ?", 
	#		Date.today, Date.today.next_month.beginning_of_month])
end