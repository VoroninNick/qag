class AddFieldsToUsers < ActiveRecord::Migration
  def change
    change_table User.table_name do |t|

      t.string :first_name
      t.string :last_name
      t.string :contact_phone
      t.string :city
      t.string :company
      #t.string :work_position
      t.string :description
    end
  end
end
