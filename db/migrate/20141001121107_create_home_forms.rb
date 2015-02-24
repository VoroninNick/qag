class CreateHomeForms < ActiveRecord::Migration
  def change
    create_table :home_forms do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :message
      t.string :locale

      t.timestamps
    end
  end
end
