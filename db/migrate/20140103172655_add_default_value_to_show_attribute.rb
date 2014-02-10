class AddDefaultValueToShowAttribute < ActiveRecord::Migration
  def change
  	change_column :inputs, :status, :string, :default => 'active'
  end
end
