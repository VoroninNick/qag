class CmsCreateTables < ActiveRecord::Migration
  def up
    Cms.create_tables(except: [:form_configs])
  end

  def down
    Cms.drop_tables(except: [:form_configs])
  end
end