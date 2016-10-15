class DbCopier
  def self.copy_rows(input_tables, output_tables)
    input_tables.each_with_index do |data, table_index|
      table_name, table_columns = data
      rows = ActiveRecord::Base.connection.execute("select #{table_columns.join(",")} from #{table_name}")
      input_rows = rows.map{|r| r.values }
      output_table_column_names = output_tables[output_tables.keys[table_index]]
      output_rows = []
      output_rows = rows.map.with_index do |row_data, row_index|
        output_table_column_names.map.with_index do |column_name, column_index|
            rows[row_index][column_name]
        end
      end

      puts "------------input_rows: #{input_rows.inspect}"
      puts "------------output_rows: #{output_rows.inspect}"
    end

    nil
  end

  def self.run_copying
    DbCopier.copy_rows(
        {voronin_studio_page_metadata: ["id", "page_type", "page_id", "head_title", "meta_description", "meta_keywords"] },
        {seo_tags: ["id", "page_type", "page_id", "title", "description", "keywords"]})

    DbCopier.copy_rows(
                {voronin_studio_page_metadatum_translations: ["id", "voronin_studio_page_metadatum_id", "locale", "created_at", "updated_at", "head_title", "meta_keywords", "meta_description"]},
                {}
    )
  end
end

