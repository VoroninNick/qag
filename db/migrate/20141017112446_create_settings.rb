class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :social_twitter
      t.string :social_facebook
      t.string :social_odnoklassniki
      t.string :social_linked_in
      t.string :social_blogger
      t.string :social_vk
      t.string :social_google_plus
      t.timestamps
    end
  end
end
