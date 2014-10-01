class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user, index: true
      t.string :commentable_type
      t.integer :commentable_id
      t.text :comment_text
      t.boolean :published
      t.integer :order_index

      t.timestamps
    end
  end
end
