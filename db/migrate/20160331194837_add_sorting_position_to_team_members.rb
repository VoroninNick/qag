class AddSortingPositionToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :sorting_position, :integer
  end
end
