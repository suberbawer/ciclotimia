class Report < Caja
	include ActiveModel::Validations

	attr_readonly :status
	before_save :set_default

	def set_default
		self.status = "report" unless self.status
	end
	
end