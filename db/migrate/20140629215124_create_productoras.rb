class CreateProductoras < ActiveRecord::Migration
  def change
    create_table :productoras do |t|
      t.string :name
      t.integer :rut
      t.string :address

      t.timestamps
    end
  end
end
