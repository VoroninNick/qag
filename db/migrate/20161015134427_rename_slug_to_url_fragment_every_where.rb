class RenameSlugToUrlFragmentEveryWhere < ActiveRecord::Migration
  def up
    tables.each do |table_name|
      if columns(table_name).map{|c| c.name.to_s }.include?("url_fragment")
        rename_column table_name, "url_fragment", :url_fragment
      end
    end
  end
end
