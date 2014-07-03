class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :lastname
      t.integer :productora_id
      t.integer :phone

      t.timestamps
    end
  end
end
