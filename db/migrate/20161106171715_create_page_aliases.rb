class CreatePageAliases < ActiveRecord::Migration
  def change
    create_table :page_aliases do |t|
      t.string :url, unique: true, null: false
      t.integer :page_id
      t.string :page_type

      t.timestamps
    end
  end
end
