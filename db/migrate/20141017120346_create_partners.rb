class CreatePartners < ActiveRecord::Migration
  def up
    model = Partner
    create_table model.table_name do |t|
      t.boolean :published
      t.has_attached_file :avatar
      t.string :avatar_file_name_fallback
      t.string :avatar_alt
      t.string :name
      t.string :link
      t.string :short_description

      t.timestamps
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end

  end

  def down
    model = TeamMember
    drop_table model.table_name

    model.drop_translation_table!
  end
end
