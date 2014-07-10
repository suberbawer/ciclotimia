class AddEmailToStaffs < ActiveRecord::Migration
  def change
    add_column :staffs, :email, :string
  end
end
