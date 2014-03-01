class AddProviderIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :provider_id, :integer
  end
end
