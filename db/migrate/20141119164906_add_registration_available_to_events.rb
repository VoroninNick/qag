class AddRegistrationAvailableToEvents < ActiveRecord::Migration
  def change
    change_table Event.table_name do |t|
      t.boolean :registration_enabled
    end
  end
end
