class CreateUserFeedbacks < ActiveRecord::Migration
  def change
    create_table :user_feedbacks do |t|
      t.has_attached_file :avatar
      t.string :name
      t.string :status
      t.boolean :published
      t.text :comment_text

      t.timestamps
    end

    change_table UserFeedback.table_name do |t|
      t.belongs_to :home_page
    end
  end
end
