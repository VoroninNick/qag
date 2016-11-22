class AddRediectUrlToPageAliases < ActiveRecord::Migration
  def change
    add_column :page_aliases, :redirect_url, :string
  end
end
