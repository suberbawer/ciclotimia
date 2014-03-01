class Article < ActiveRecord::Base
	belongs_to :transaction
	belongs_to :input
	belongs_to :output
	belongs_to :provider

	# Devuelve true si el articulo tiene un input asociado, de otra forma false.
	def has_input
		# Mientras tenga input_id no se puede usar (se vendio, o esta siendo alquilada ahora,
		# cuando se devuelve el articulo se dessetea el input_id).
	end

	def set_status(input_status)
		new_status = ""
		case input_status
		when "Sale"
			new_status = "sold"  
		when "Rent"
		  	new_status = "rented"
		when "OtherInput"
		  	new_status = ""
		else
		  	new_status = "Output"
		end
		self.status = new_status
		self.save
	end
	
	def self.get_barcode(articleId)
		require 'barby'
		require 'barby/barcode/code_128' 
		require 'barby/outputter/svg_outputter'
		require 'barby/outputter/png_outputter'

		# if the barcode image doesn't already exist then generate and save it
		fname = articleId.to_s+'.png';

		if ! File.exists?(fname)
		 
			str = 'Barcode.new("'+articleId.to_s+'")'
			 
			begin
			barcode = eval str
		
			rescue Exception => exc
				barcode = Barby::Code128B.new(articleId) # fall back to Code128 type B
			end
		 
			File.open(File.join("app/assets/images/barcodes", fname), 'w') do |f|
				f.write Barby::PngOutputter.new(barcode).to_png
			end
		end
	end
	
	def return_article
		if self.status == "rented"
			self.status = ""
			return self.save
		end
		return false	
	end
end
