class AddDisabledRegistrationFieldToEvents < ActiveRecord::Migration
  def change
    add_column :events, :disabled_registration, :boolean
  end
end
