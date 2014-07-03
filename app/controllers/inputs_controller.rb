class InputsController < ApplicationController
	before_action :set_input, only: [:show]

  	def index

	end

	def new
		c_response = Collect.get_open_caja
		if c_response['result'] != 'ok'
			flash[:notice] = c_response['message']
		end
	end

	def create
		@input = Input.new(input_params)

	    respond_to do |format|
	      if @input.save
	        format.html { redirect_to @input, notice: 'Input was successfully created.' }
	        format.json { render action: 'show', status: :created, location: @input }
	      else
	        format.html { render action: 'new' }
	        format.json { render json: @input.errors, status: :unprocessable_entity }
	      end
	    end
	end

	# Recibe una lista de inputs desde la vista y los manda al modelo para salvarlos (tambien los agrega a la caja de hoy (si hay)).
	def bulk_save
		response_message = Input.save_inputs(params[:inputList])		
	   	render json: {message: response_message}
	end

	def show
		
	end

	def input_article
		c_response = Collect.get_open_caja
		if c_response['result'] != 'ok'
			flash[:notice] = c_response['message']
		end
	end

	def new_manual_input
		#response_message = Input.save_inputs(params[:inputList])
		params[:type]  = 'other_input'
		new_input      = Input.save_single_input(params)
		flash[:notice] = (new_input) ? 'La transacción manual se realizo correctamente' : 'La transacción no se pudo realizar'
		redirect_to controller: :collects, action: :today_collect
	end

	def batch_receipt
		@new_inputs = Input.where(id: params['inputs'])
	end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_input
	      @input = Input.find(params[:id])
	    end
end