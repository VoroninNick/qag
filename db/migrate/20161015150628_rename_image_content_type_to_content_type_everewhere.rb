class RenameImageContentTypeToContentTypeEverewhere < ActiveRecord::Migration
  def up
    pattern = /_image_content_type\Z/
    replacement = "_content_type"
    tables.each do |table_name|
      columns(table_name).map{|c| c.name.to_s }.select{|s| s.scan(pattern).any? }.each do |column_name|
        rename_column table_name, column_name, column_name.gsub(pattern, replacement)
      end
    end
  end
end
