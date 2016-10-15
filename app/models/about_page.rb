class AboutPage < ActiveRecord::Base
  attr_accessible *attribute_names

  def slider_slides
    AboutPageSliderSlide.all
    #"hello"
  end

  has_many :about_page_slider_slides
  has_many :team_members
  has_many :participants

  [:about_page_slider_slides, :team_members, :participants].each do |a|
    accepts_nested_attributes_for a, allow_destroy: true
    attr_accessible a, "#{a}_attributes".to_sym
  end

  has_seo_tags

  attr_accessible :top_text, :quote, :bottom_text, :team_text, :participants_text

  image :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }


end
