class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :name
      t.string :lastname
      t.string :phone
      t.string :email
      t.string :address
      t.string :ci

      t.timestamps
    end
  end
end
