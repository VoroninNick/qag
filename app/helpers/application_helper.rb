module ApplicationHelper
  def stub_image_link(width = 420, height = 350, text = 'item 1')
    image_url = "http://placehold.it/#{width}x#{height}&text=#{text}"
    image_url
  end

  def stub_image(width = 420, height = 350, text = 'item 1', options = {})
    image_url = stub_image_link
    options[:src] = image_url
    output = "<img "
    options.each_pair do |key, value|
      output += "#{key}='#{value}' "
    end
    output += "/>"
    output.html_safe
  end

  def self.self_js_embedded_svg filename, options={}
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    source = svg.to_html
    minimized_source = source
    minimized_source = minimized_source.remove("\r")
    minimized_source = minimized_source.remove("\t")
    minimized_source = minimized_source.remove("\n")
    minimized_source
  end

  def js_embedded_svg filename, options={}
    self.self_js_embedded_svg(filename, options)
  end

  def self.self_embedded_svg_from_assets filename, options = {}
    self.self_embedded_svg("/app/assets/images/#{filename}", options)
  end

  def embedded_svg_from_assets filename, options = {}
    ApplicationHelper.self_embedded_svg_from_assets(filename, options)
  end

  def embedded_svg_from_public filename, options = {}
    self.self_embedded_svg("#{filename}", options)
  end

  def self.self_embedded_svg_from_public filename, options = {}
    embedded_svg("/public/#{filename}", options)
  end

  def self.self_embedded_svg filename, options={}
    self.self_embedded_svg_from_absolute_path(Rails.root.to_s + filename.to_s, options)
  end

  def embedded_svg filename, options={}
    self.class.self_embedded_svg(filename, options)
  end

  def self.self_embedded_svg_from_absolute_path(filename, options = {})
    file = File.read(filename.to_s)
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    doc.to_html.html_safe
  end

  def embedded_svg_from_absolute_path(filename, options = {})
    self.class.self_embedded_svg_from_absolute_path(filename, options)
  end

  def image_or_stub_url(paperclip_instance, style = :original, width=250, height=250, text='image')
    ( (paperclip_instance && paperclip_instance.respond_to?(:exists?) && paperclip_instance.exists?(style) && paperclip_instance.respond_to?(:url) )? paperclip_instance.url(style) : stub_image_link(width, height, text) )
  end




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

  def get_button_name_for_event(event)
    button_options = { type: nil }

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

    return button_options
  end


  def get_button_for_event(event)
    if event
      button_options = get_button_name_for_event(event)
      render template: "helpers/application_helper/get_button_for_event", locals: { event: event, button_options: button_options}
    end
  end
end