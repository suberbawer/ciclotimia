class RenameProductorasColumn < ActiveRecord::Migration
  def change
  	def self.up
    	rename_column :productora, :address, :billing_name
  	end
  end
end
