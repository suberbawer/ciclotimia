class CreateCajas < ActiveRecord::Migration
  def change
    create_table :cajas do |t|
      t.decimal :fecha

      t.timestamps
    end
  end
end
