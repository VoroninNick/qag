class AddDaysAndTimeStringFieldToEvent < ActiveRecord::Migration
  def change
    model = Event
    add_column model.table_name, :days_and_time_string, :string
    add_column model.translation_class.table_name, :days_and_time_string, :string if model.respond_to?(:translates?) && model.translates?
  end
end
