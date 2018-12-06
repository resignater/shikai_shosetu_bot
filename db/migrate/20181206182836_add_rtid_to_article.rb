class AddRtidToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :rtid, :string
  end
end
