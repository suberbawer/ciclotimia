class CreateOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.integer :caja_id
      t.integer :caja_transaction_id

      t.timestamps
    end
  end
end
