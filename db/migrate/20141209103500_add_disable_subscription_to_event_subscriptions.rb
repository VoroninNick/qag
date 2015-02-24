class AddDisableSubscriptionToEventSubscriptions < ActiveRecord::Migration
  def change
    add_column :event_subscriptions, :disabled, :boolean
  end
end
