class AddDefaultValueToShowAttribute < ActiveRecord::Migration
  def change
  	add_column :inputs, :status, :string, :default => 'active'
  end
end
