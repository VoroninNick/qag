class AddEventIdToGalleryImage < ActiveRecord::Migration
  def change
    change_table EventGalleryImage.table_name do |t|
      t.belongs_to :event
    end
  end
end
