class TeamMember < ActiveRecord::Base
  include Member

  belongs_to :about_page
  attr_accessible :about_page

  before_create do
    self.about_page = AboutPage.first
  end

  has_cache
  def cache_instances
    [AboutPage.first]
  end
end
