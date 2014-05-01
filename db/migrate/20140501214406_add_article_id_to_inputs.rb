class AddArticleIdToInputs < ActiveRecord::Migration
  def change
    add_column :inputs, :article_id, :string
  end
end
