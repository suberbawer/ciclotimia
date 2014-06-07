class AddFueraCajaToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :fuera_caja, :boolean, :default => false 
  end
end
