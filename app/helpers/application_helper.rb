module ApplicationHelper
  # =====================================================
  # -----------------------------------------------------
  # helpers for offline devise
  # -----------------------------------------------------
  # =====================================================

  def resource_name
    :user
  end

  def resource
    #@resource ||= User.new
    if !@resource
      if user_signed_in?
        @resource = current_user
      else
        @resource = User.new
      end
    else
      @resource = User.new
    end
    @resource
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end



  # =====================================================
  # -----------------------------------------------------
  # helpers for events
  # -----------------------------------------------------
  # =====================================================

  def number_to_string_with_zero(number, characters_count = 2 )
    num_str = number.to_s

    if num_str.length < characters_count
      num_str = '0'*(characters_count - num_str.length ) + num_str
    end

    num_str
  end


  def get_field_label field
    I18n.t('rails_admin.field_labels.address')
  end

  def get_button_name_for(object)
    button_options = { type: nil }
    if object.is_a?(Event)
      event = object
      if event.course?
        button_options[:type] = :register

        return button_options
      end

      if event.up_to_date?
        if event.enabled_registration?
          if subscribed_on_event?(event.id)
            # unregister
            # or
            # if disabled by admin
            # frozen
            if event.disabled_by_admin_for_user?(current_user)
              button_options[:type] = :frozen
            else
              button_options[:type] = :unregister
            end
          else
            button_options[:type] = :register
          end
        else
          # registration disabled
          button_options[:type] = :registration_disabled
        end
      else
        button_options[:type] = :event_expired
      end

      if current_route?(:event_item)
        button_options[:context] = :event_item
      elsif current_route?(:events_list)
        button_options[:context] = :events_list_page
      else
        button_options[:context] = :list_item
      end
    elsif object.is_a?(Article)
      button_options[:type] = :read_article
    end

    return button_options
  end


  def get_button_for(object, options = {})
    return nil if object.nil?
    button_options = get_button_name_for(object)
    locals = { button_options: button_options, options: options, resource: object }
    locals[:event] = object if object.is_a?(Event)
    locals[:article] = object if object.is_a?(Article)

    render template: "helpers/application_helper/get_button_for", locals: locals
  end

  def host_name
    "qagroup.com.ua"
  end
end