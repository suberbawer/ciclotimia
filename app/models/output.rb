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
    	output[:type] = 'Output'
    	output[:amount] = output_data[:amount].to_i * -1
    	output[:concept] = output_data[:concept]
		return output
	end

	# Crea una copia de this (con amount inverso) y lo devuelve. 
	def create_cancel_transaction
		cancel_output           = Output.new
		cancel_output.amount    = self.amount * -1
		cancel_output.cancel_id = self.id
		cancel_output.status    = "cancel_input"

		self.status            = "cancelled"
		self.save
		return cancel_output
	end
end
