class CreateParticipants < ActiveRecord::Migration
  def up
    model = Participant
    create_table model.table_name do |t|
      t.boolean :published
      t.string :name
      t.has_attached_file :avatar
      t.string :avatar_file_name_fallback
      t.string :avatar_alt
      t.text :short_description

      t.timestamps
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = Participant
    drop_table model.table_name

    model.drop_translation_table!
  end
end
