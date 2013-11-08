class Rent < Input

	def build_input (input_data)
		self[:amount] = input_data[:amount].to_i * 0.7
		self.article  = Article.find input_data[:article]
	end
end