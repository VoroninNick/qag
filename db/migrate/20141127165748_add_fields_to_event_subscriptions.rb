class AddFieldsToEventSubscriptions < ActiveRecord::Migration
  def change
    add_column :event_subscriptions, :first_name, :string
    add_column :event_subscriptions, :last_name, :string
    add_column :event_subscriptions, :email, :string
    add_column :event_subscriptions, :contact_phone, :string
  end
end
