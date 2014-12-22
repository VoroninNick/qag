class AddExpiredAvatarToEvents < ActiveRecord::Migration
  def change
    add_column :events, :expired_avatar, :has_attached_file
  end
end
