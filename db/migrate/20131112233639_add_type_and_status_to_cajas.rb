class AddTypeAndStatusToCajas < ActiveRecord::Migration
  def change
    add_column :cajas, :type, :string
    add_column :cajas, :status, :string
  end
end
