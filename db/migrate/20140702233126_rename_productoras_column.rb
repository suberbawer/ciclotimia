class RenameProductorasColumn < ActiveRecord::Migration
  def change
  	def self.up
    	rename_column :productora, :address, :billing_name
  	end
  	def self.down
    	# rename back if you need or do something else or do nothing
  	end
  end
end
