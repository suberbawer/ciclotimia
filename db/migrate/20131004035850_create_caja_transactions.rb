class CreateCajaTransactions < ActiveRecord::Migration
  def change
    create_table :caja_transactions do |t|
    	t.integer :caja_id
    	t.integer :transaction_id
    	t.string  :transaction_type

      	t.timestamps
    end
  end
end
