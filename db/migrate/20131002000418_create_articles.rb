class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :description
      t.string :estimated_price
      t.date :entry_date
      t.string :commission_per
      t.string :commission_cash
      t.string :status

      t.timestamps
    end
  end
end
