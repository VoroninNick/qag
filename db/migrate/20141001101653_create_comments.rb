class CreateComments < ActiveRecord::Migration
  def up
    model = Comment
    create_table model.table_name do |t|
      t.belongs_to :user, index: true
      t.string :commentable_type
      t.integer :commentable_id

      t.text :comment_text
      t.boolean :published
      t.integer :order_index

      t.timestamps
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = Comment
    drop_table model.table_name

    model.drop_translation_table!
  end
end
