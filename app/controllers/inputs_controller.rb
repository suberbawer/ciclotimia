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

	# Recibe una lista de inputs desde la vista y los manda al modelo para salvarlos.
	def bulk_save
		params[:inputList].each do |input|
	    	new_input = Input.build_input(input[1])
	    	new_input.save
	   	end
	   	render nothing: true
	end

	def show
	end

	def new_manual_input
		new_input = Input.build_input(params)
		@is_saved = new_input.save
		render :partial => 'manual_input', :content_type => 'text/html'
	end
end