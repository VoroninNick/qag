class CreateFormConfigs < ActiveRecord::Migration
  def change
    create_table :form_configs do |t|
      t.string :name
      t.text :receiver_emails
      t.boolean :send_to_user
      t.timestamps
    end
  end
end
