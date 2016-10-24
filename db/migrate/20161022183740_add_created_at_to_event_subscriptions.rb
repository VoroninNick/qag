class AddCreatedAtToEventSubscriptions < ActiveRecord::Migration
  def change
    add_column :event_subscriptions, :created_at, :datetime
  end
end
