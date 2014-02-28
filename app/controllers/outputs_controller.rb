class OutputsController < ApplicationController

	def new

	end 

	def new_manual_output
		params[:type]  = 'other_output'
		new_output     = Output.save_single_output(params)
		flash[:notice] = (new_output) ? 'La transacción manual se realizo correctamente' : 'La transacción no se pudo realizar'
		redirect_to controller: :collects, action: :today_collect
	end
end