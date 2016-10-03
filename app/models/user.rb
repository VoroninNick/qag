class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :confirmed_at

  attr_accessible :name, :status, :role

  belongs_to :registration_event, foreign_key: :registration_event_id, class_name: "Event"

  attr_accessible :registration_event

  attr_accessible :registration_location, :registration_event_id

  attr_accessible :first_name, :last_name, :contact_phone, :city, :company, :description
  #t.string :work_position


  has_attached_file :avatar, :styles => { :thumb => '150x150#'},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        thumb: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  #phony_normalize :contact_phone, :default_country_code => 'UA'

  [:avatar].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  #has_and_belongs_to_many :events, join_table: 'event_subscriptions'
  has_many :event_subscriptions
  has_many :events, through: :event_subscriptions

  has_many :comments

  has_many :user_feedbacks

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
        field :name do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :status do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :avatar_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
      end
    end
  end

  def self.subscribed_event_ids_from_range_for_user(user_id,event_ids)
    event_ids_array = nil
    if event_ids.is_a?(Array)
      event_ids_array = event_ids
      event_ids_array_count = event_ids_array.count
    elsif event_ids.is_a?(String)
      event_ids_array = event_ids.split(',')
      event_ids_array_count = event_ids_array.count
      for i in 0..(event_ids_array_count - 1)
        event_ids_array[i] = event_ids_array[i].to_i
      end
    end




    @events_i_am_subscribed_on ||= ActiveRecord::Base.connection.execute("select s.event_id as event_id from event_subscriptions s where s.user_id = #{user_id}")
    @event_ids_i_am_subscribed_on ||= []
    if @event_ids_i_am_subscribed_on.count == 0 && @events_i_am_subscribed_on.count > 0
      @events_i_am_subscribed_on.each do |e|
        @event_ids_i_am_subscribed_on.push e['event_id']
      end
    end
    #return @events_i_am_subscribed_on.where("event_id = #{event_id}").count > 0
    result = @event_ids_i_am_subscribed_on.select {|num| event_ids_array.include?(num)  }

    #return @event_ids_i_am_subscribed_on.index(event_id) != nil
    return result

  end

  def custom_label_method
    self.email
  end




  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.other')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")


    object_label_method do
      :custom_label_method
    end

    list do
      field :first_name
      field :last_name
      field :email
      field :contact_phone
      field :confirmed_at
    end


    edit do
      field :role do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :first_name do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :last_name do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :email do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :contact_phone do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :password do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :password_confirmation do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :city do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :company do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :status do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :description do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end



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
      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end

      end
      field :avatar_file_name_fallback do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end



end
