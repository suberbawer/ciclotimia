class OtherInput < Input

	def build_input (input_data)
		self[:amount]  = input_data[:amount]
		self[:concept] = input_data[:concept]
	end
end