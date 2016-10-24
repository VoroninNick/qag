class RenameAboutPageColumns < ActiveRecord::Migration
  def change
    rename_column :about_pages, :participants_text, :about_partners_text
  end
end
