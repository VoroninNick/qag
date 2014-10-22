class CreateEventTags < ActiveRecord::Migration
  def up
    model = EventTag

    create_table model.table_name do |t|
      t.string :name
      t.timestamps
    end

    model.create_translation_table!(name: :string)

    create_table :event_taggings do |t|
      t.belongs_to :event
      t.belongs_to :event_tag
    end


  end

  def down
    model = EventTag

    drop_table model.table_name

    model.drop_translation_table

    drop_table :event_taggings
  end
end
