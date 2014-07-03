class AddColumnToInputs < ActiveRecord::Migration
  def change
    add_column :inputs, :staff_id, :integer
  end
end
