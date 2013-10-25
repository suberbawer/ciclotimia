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

	def show
		@inputs = Array.new
	end

	def new_manual_input
		is_saved = Input.insert_input(params)
		render :partial => 'manual_input', :content_type => 'text/html'
	end

	def insert_input

	end

end