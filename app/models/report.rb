class Report < Caja
	include ActiveModel::Validations

	attr_readonly :status
	before_save :set_default

	def set_default
		self.status = "report" unless self.status
	end

	def self.reports_between_dates(start_date, end_date)
		if start_date != ''
			if start_date == 'mes'
				start_date = Date.today.beginning_of_month.beginning_of_day
				end_date   = Date.today.end_of_month.end_of_day
			elsif start_date == 'diario'
				start_date = Date.today.beginning_of_day
				end_date   = Date.today.end_of_day
			else 
				start_date = Date.strptime(start_date, "%m/%d/%Y").beginning_of_day
				end_date   = Date.strptime(end_date, "%m/%d/%Y").end_of_day
			end
		end	
				
		return Input.find(:all, :conditions => ["created_at between ? and ?", start_date, end_date])
	end

	def self.total_amount(list_transactions)
		aux = 0;
		total_amount = 0;
		list_transactions.each do |transaction|
			aux = transaction.amount
			total_amount = aux + total_amount
		end

		return total_amount
	end
end