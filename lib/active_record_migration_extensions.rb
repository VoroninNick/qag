module ActiveRecordMigrationExtensions
  # Example:
  # rename_columns(:my_table, old_column1_name: :new_column1_name, old_column2_name: :new_column2_name)
  def rename_columns(table_name, rename_hash)
    if table_name.blank?
      raise ArgumentError, "please provide table_name"
    end
    if !rename_hash.is_a?(Hash)
      raise ArgumentError, "please provide hash with columns to rename. Example: rename_columns(:my_table, old_column1_name: :new_column1_name, old_column2_name: :new_column2_name)"
    end
    reversible do |dir|
      rename_hash.keep_if{|k, v| v.present? }.each do |old_column_name, new_column_name|
        dir.up { rename_column table_name, old_column_name, new_column_name }
        dir.down { rename_column table_name, new_column_name, old_column_name }

      end
    end
  end
end

#ActiveRecord::ConnectionAdapters::SchemaStatements.send(:extend)
include ActiveRecordMigrationExtensions