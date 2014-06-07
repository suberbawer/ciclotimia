class AddLastTotalCajaToCajas < ActiveRecord::Migration
  def change
    add_column :cajas, :last_total_caja, :integer
  end
end
