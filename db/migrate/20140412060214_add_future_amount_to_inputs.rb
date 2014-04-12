class AddFutureAmountToInputs < ActiveRecord::Migration
  def change
  	add_column :inputs, :future_amount, :string
  end
end
