class TranslateTags < ActiveRecord::Migration
  def self.up
    model = ActsAsTaggableOn::Tag

    if model.respond_to?(:create_translation_table!)


    ActsAsTaggableOn::Tag.create_translation_table!({
        :name => :string
    }, {
        :migrate_data => true
    })

    end
  end

  def self.down
    model = ActsAsTaggableOn::Tag
    if model.respond_to?(:drop_translation_table!)
      model.drop_translation_table! :migrate_data => true
    end
  end
end

