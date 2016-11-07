class PageAlias < ActiveRecord::Base
  attr_accessible *attribute_names
  belongs_to :page, polymorphic: true
  attr_accessible :page
end
