class AboutPartner < ActiveRecord::Base
  include Member

  # before_create do
  #   self.about_page = AboutPage.first
  # end

  has_cache
  def cache_instances
    [AboutPage.first]
  end
end