class AddSortingPositionToAboutPageSliderSlides < ActiveRecord::Migration
  def change
    add_column :about_page_slider_slides, :sorting_position, :integer
  end
end
