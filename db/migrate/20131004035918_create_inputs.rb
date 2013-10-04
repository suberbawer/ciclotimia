class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.decimal :amount
      t.integer :caja_id
      t.integer :caja_transaction_id
      
      t.timestamps
    end
  end
end
