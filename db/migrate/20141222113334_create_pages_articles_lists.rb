class CreatePagesArticlesLists < ActiveRecord::Migration
  def change
    create_table :pages_articles_lists do |t|
      t.has_attached_file :banner

      t.timestamps
    end
  end
end
