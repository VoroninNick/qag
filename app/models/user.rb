class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation

  attr_accessible :name, :status, :role

  has_attached_file :avatar, :styles => { :thumb => '150x150#'},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        thumb: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  [:avatar].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  has_and_belongs_to_many :events, join_table: 'event_subscriptions'

  has_many :comments

  translates :name, :avatar_alt, :status, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :name, :status, :published_translation, :avatar_alt

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :status
        field :avatar_alt
      end
    end
  end


  rails_admin do

    edit do
      field :translations, :globalize_tabs
      field :email
      field :password
      field :password_confirmation
      # field :reset_password_sent_at do
      #   read_only true
      # end
      # field :remember_created_at do
      #   read_only true
      # end
      # field :sign_in_count do
      #   read_only true
      # end
      # field :current_sign_in_at do
      #   read_only true
      # end
      # field :current_sign_in_ip do
      #   read_only true
      # end
      # field :last_sign_in_ip do
      #   read_only true
      # end
      #field :status
      field :avatar
      field :avatar_file_name_fallback
    end
  end



end
