class AddUserToUserFeedbacks < ActiveRecord::Migration
  def change
    add_column :user_feedbacks, :user_id, :integer
  end
end
