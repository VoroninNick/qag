class HomePage < ActiveRecord::Base
  has_many :home_about_us_slides
  has_many :home_contact_infos
  has_many :comments, as: :commentable
  has_many :main_slider_slides

  accepts_nested_attributes_for :home_about_us_slides
  attr_accessible :home_about_us_slides_attributes, :home_about_us_slides

  accepts_nested_attributes_for :home_contact_infos
  attr_accessible :home_contact_infos_attributes, :home_contact_infos

  accepts_nested_attributes_for :comments
  attr_accessible :comments_attributes, :comments

  accepts_nested_attributes_for :main_slider_slides
  attr_accessible :main_slider_slides_attributes, :main_slider_slides

  rails_admin do
    weight -100
    navigation_label 'Pages'
    edit do
      field :main_slider_slides
      field :home_about_us_slides
      field :home_contact_infos
      field :comments
    end
  end

end
