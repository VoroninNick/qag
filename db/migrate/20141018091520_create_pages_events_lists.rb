class CreatePagesEventsLists < ActiveRecord::Migration
  def change
    create_table :pages_events_lists do |t|

      t.timestamps
    end
  end
end
