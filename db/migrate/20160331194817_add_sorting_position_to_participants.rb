class AddSortingPositionToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :sorting_position, :integer
  end
end
