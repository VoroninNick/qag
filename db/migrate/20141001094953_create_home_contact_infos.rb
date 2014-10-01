class CreateHomeContactInfos < ActiveRecord::Migration
  def up
    model = HomeContactInfo
    create_table :home_contact_infos do |t|
      t.string :address
      t.string :address_at
      t.string :info_service_email
      t.string :info_service_phone
      t.string :support_email

      t.float :map_latitude
      t.float :map_longtitude

      t.belongs_to :home_page

      t.timestamps
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = HomeContactInfo

    drop_table model.table_name

    model.drop_translation_table!
  end
end
