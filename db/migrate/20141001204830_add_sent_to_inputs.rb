class AddSentToInputs < ActiveRecord::Migration
  def change
    add_column :inputs, :sent, :boolean
  end
end
