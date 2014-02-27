class InputsController < ApplicationController

  	def index

	end

	def new

	end

	def list
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

	def new_manual_input
		#response_message = Input.save_inputs(params[:inputList])
		params[:type]  = 'other_input'
		new_input      = Input.save_single_input(params)
		flash[:notice] = (new_input) ? 'La transacción manual se realizo correctamente' : 'La transacción no se pudo realizar'
		redirect_to controller: :collects, action: :today_collect
	end
end