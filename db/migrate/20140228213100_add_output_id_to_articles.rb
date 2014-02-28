class AddOutputIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :output_id, :integer
  end
end
