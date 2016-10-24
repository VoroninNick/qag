class AddArchivedAtToEventSubscriptions < ActiveRecord::Migration
  def change
    add_column :event_subscriptions, :archived_at, :datetime
  end
end
