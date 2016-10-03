class AddFeaturedToUserFeedbacks < ActiveRecord::Migration
  def change
    add_column :user_feedbacks, :featured, :boolean
  end
end
