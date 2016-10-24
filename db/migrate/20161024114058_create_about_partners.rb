class CreateAboutPartners < ActiveRecord::Migration
  def up
    create_table :about_partners do |t|
      t.boolean :published
      t.integer :sorting_position

      t.string :name
      t.attachment :avatar
      t.string :avatar_file_name_fallback
      t.string :avatar_alt
      t.text :short_description

      t.timestamps

      t.string :social_twitter
      t.string :social_facebook
      t.string :social_odnoklassniki
      t.string :social_linked_in
      t.string :social_blogger
      t.string :social_vk
      t.string :social_google_plus
    end

    AboutPartner.create_translation_table(name: :string, short_description: :text, avatar_alt: :string)
  end

  def down
    AboutPartner.drop_translation_table!

    drop_table :about_partners
  end
end
