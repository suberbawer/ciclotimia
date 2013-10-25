class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.integer :caja_id
      t.integer :caja_transaction_id
      t.string  :type  
      t.integer :amount  
      t.timestamps
    end
  end
end
