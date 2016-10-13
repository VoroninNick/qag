class CreateCallBacks < ActiveRecord::Migration
  def change
    create_table :call_backs do |t|
      t.string :first_name
      t.string :last_name
      t.string :contact_phone
      t.integer :user_id

      t.timestamps
    end
  end
end
