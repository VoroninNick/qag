class AddShowTonedAvatarImageToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :show_toned_avatar, :boolean
    add_column :articles, :show_toned_banner, :boolean
  end
end
