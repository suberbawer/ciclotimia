class OutputsController < ApplicationController
	before_action :set_output, only: [:show]

	def new
		c_response = Collect.get_open_caja
		if c_response['result'] != 'ok'
			flash[:notice] = c_response['message']
		end
	end 

	def new_manual_output
		params[:type]  = 'other_output'
		new_output     = Output.save_single_output(params)
		flash[:notice] = (new_output) ? 'La transacción manual se realizo correctamente' : 'La transacción no se pudo realizar'
		redirect_to controller: :collects, action: :today_collect
	end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_output
	      @output = Output.find(params[:id])
	    end
end