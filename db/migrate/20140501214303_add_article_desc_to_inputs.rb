class AddArticleDescToInputs < ActiveRecord::Migration
  def change
    add_column :inputs, :article_desc, :string
  end
end
