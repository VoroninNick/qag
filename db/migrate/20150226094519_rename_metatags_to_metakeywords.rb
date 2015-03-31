class RenameMetatagsToMetakeywords < ActiveRecord::Migration
  def change
    model = VoroninStudio::PageMetadata
    rename_column model.table_name, :meta_tags, :meta_keywords
    rename_column model.translation_class.table_name, :meta_tags, :meta_keywords
  end
end