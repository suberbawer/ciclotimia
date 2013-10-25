class AddInputIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :input_id, :integer
  end
end
