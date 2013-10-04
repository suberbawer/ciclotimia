class CajaTransaction < ActiveRecord::Base
	belongs_to :caja
	belongs_to :transaction, :polymorphic => true
end
