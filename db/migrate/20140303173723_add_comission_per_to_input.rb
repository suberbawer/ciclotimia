class AddComissionPerToInput < ActiveRecord::Migration
  def change
    add_column :inputs, :comission_per, :string
  end
end
