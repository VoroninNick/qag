class CreateContactPages < ActiveRecord::Migration
  def change
    create_table :contact_pages do |t|

      t.timestamps
    end
  end
end
