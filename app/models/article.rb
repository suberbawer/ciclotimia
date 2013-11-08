class Article < ActiveRecord::Base
	belongs_to :transaction
	belongs_to :input

	# Devuelve si el articulo tiene un input asociado.
	def has_input
		# Mientras tenga input_id no se puede usar (se vendio, o esta siendo alquilada ahora,
		# cuando se devuelve el articulo se dessetea el input_id).
	end
end
