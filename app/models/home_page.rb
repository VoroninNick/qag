class HomePage < ActiveRecord::Base
  has_many :home_about_us_slides
  has_many :home_contact_infos
  has_many :comments, as: :commentable
  has_many :main_slider_slides

end
