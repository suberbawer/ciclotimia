class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.integer :caja_id
      t.integer :caja_transaction_id
      t.string  :type  
      t.integer :amount
      t.integer :cancel_id
      t.string  :status, :default => 'active'
      t.timestamps
    end
  end
end
