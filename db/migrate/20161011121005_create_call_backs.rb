class CreateCallBacks < ActiveRecord::Migration
  def change
    create_table :call_backs do |t|
      t.string :name
      t.string :phone
      t.integer :user_id

      t.timestamps
    end
  end
end
