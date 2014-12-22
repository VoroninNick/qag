class AddExpiredAvatarToEvents < ActiveRecord::Migration
  def up
    #add_column :events, :expired_avatar

    field_name = 'expired_event_avatar'
    arr = [{:name=>"_file_name", :type=>:string}, {:name=>"_image_content_type", :type=>:string}, {:name=>"_file_size", :type=>:integer}, {:name=>"_updated_at", :type=>:datetime}, {:name=>"_file_name_fallback", :type=>:string}, {:name=>"_alt", :type=>:string}]
    arr.each do |column|
      add_column Event.table_name, "#{field_name}#{column[:name]}".to_sym, column[:type]
    end

  end

  def down
    field_name = 'expired_event_avatar'
    arr = [{:name=>"_file_name", :type=>:string}, {:name=>"_image_content_type", :type=>:string}, {:name=>"_file_size", :type=>:integer}, {:name=>"_updated_at", :type=>:datetime}, {:name=>"_file_name_fallback", :type=>:string}, {:name=>"_alt", :type=>:string}]
    arr.each do |column|
      remove_column Event.table_name, "#{field_name}#{column[:name]}".to_sym, column[:type]
    end
  end
end
