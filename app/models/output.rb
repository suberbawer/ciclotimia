class Output < ActiveRecord::Base
	has_one :caja_transaction, :as =>:transaction
	has_one :caja, :through => :caja_transactions
	has_one :article
	accepts_nested_attributes_for :article

	def self.save_single_output (output_data)
		json_response = Collect.get_open_caja
		if json_response['result'] == 'ok'
			current_open = json_response['record']
			new_output = self.build_output(output_data)
		    current_open.caja_transactions.create!(:transaction => new_output)
		end
		return new_output
	end

	def self.build_output (output_data)
    	output = Output.new
    	output[:amount] = output_data[:amount]
    	output[:concept] = output_data[:concept]
		return output
	end
end
