class AddDateToCajas < ActiveRecord::Migration
  def change
    add_column :cajas, :start_Date, :string
    add_column :cajas, :datetime, :string
    add_column :cajas, :end_date, :datetime
  end
end
