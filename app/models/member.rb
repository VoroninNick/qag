module Member
  def self.included(base)
    base.attr_accessible :published, :name, :short_description

    base.attr_accessible :social_twitter, :social_facebook, :social_odnoklassniki, :social_linked_in, :social_blogger, :social_vk, :social_google_plus

    base.image :avatar, :styles => { :about => '250x250#'},
               :url  => "/uploads/#{base.name.underscore}/:id/avatar/:style/:basename.:extension",
               :path => ":rails_root/public:url",
               convert_options: {
                   about: "-quality 94 -interlace Plane",
               }

    base.boolean_scope :published
    base.scope :sort_by_sorting_position, -> { base.order("sorting_position asc") }

    base.globalize :name, :short_description, :avatar_alt

  end

  def get_social_links
    result = {}

    [:twitter, :facebook, :odnoklassniki, :linked_in, :blogger, :vk, :google_plus].each do |field_name|
      value = send("social_#{field_name}")
      if value && value.length > 0
        result[field_name] = value
      end
    end

    result
  end
end