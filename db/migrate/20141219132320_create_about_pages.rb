class CreateAboutPages < ActiveRecord::Migration
  def change
    create_table :about_pages do |t|
      t.has_attached_file :banner
      t.text :top_text
      t.text :quote
      t.text :bottom_text
      t.text :team_text
      t.text :participants_text
      t.timestamps
    end

    models = [AboutPageSliderSlide, TeamMember, Participant]
    tables = models.map {|m| m.table_name }
    tables.each do |table_name|
      change_table table_name do |t|
        t.belongs_to :about_page
      end
    end
  end
end
