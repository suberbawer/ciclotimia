class AddComissionCashToInput < ActiveRecord::Migration
  def change
    add_column :inputs, :comission_cash, :string
  end
end
