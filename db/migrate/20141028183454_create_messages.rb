class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.text :text

      t.timestamps
    end
  end
end
