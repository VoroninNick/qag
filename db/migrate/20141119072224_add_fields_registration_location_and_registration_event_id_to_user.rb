class AddFieldsRegistrationLocationAndRegistrationEventIdToUser < ActiveRecord::Migration
  def change
    change_table User.table_name do |t|
      t.string :registration_location
      t.integer :registration_event_id
    end
  end
end
