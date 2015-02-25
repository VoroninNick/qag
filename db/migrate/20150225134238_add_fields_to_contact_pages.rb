class AddFieldsToContactPages < ActiveRecord::Migration
  def up
    add_column :contact_pages, :address, :string
    ContactPage.create_translation_table!(address: :string)
  end

  def down
    remove_column :contact_pages, :address
    ContactPage.drop_translation_table!
  end
end
