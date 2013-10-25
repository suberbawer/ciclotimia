class SalesController < ApplicationController
  	
  	def index

	end

	def new

	end	

	def create
		@sale = Sale.new(sale_params)

		respond_to do |format|
		  if @sale.save
		    format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
		    format.json { render action: 'show', status: :created, location: @sale }
		  else
		    format.html { render action: 'new' }
		    format.json { render json: @sale.errors, status: :unprocessable_entity }
		  end
		end
	end

	def manual_transaction


	end

	def show

	end

end