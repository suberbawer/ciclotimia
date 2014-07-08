class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :productoras, :address, :billing_name
  end
end
