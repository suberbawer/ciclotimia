class OtherInput < Input

	def build_input (input_data)
		self[:amount] = input_data[:amount]
		self.article  = Article.find input_data[:article]
	end
end