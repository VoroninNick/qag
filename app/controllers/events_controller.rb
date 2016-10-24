class EventsController < ApplicationController
  caches_page :item
  def find_event
    params_item = params[:item]
    event_type = params[:event_type]
    @event_ids_rows = Event.find_by_sql("select t.event_id as id from #{Event.translation_class.table_name} t where t.locale='#{I18n.locale}' and t.url_fragment='#{params_item}'")
    @event_ids = []
    @event_ids_rows.each {|e| @event_ids.push e['id']  }
    @events = Event.where(event_type: event_type).where(id: @event_ids)
    @event = (@events.respond_to?(:count) && @events.count > 0)? @events.first : nil

    if @event
      @event.translations_by_locale.keys.each do |locale|
        I18n.with_locale(locale.to_sym) do
          @page_locale_links[locale.to_sym] = url_for(item: @event.url_fragment, tags: @event.tags.join('-'))
        end

      end
    end
  end

  def item
    
    find_event

    if @event
      @events_list_key = "#{@event.event_type.pluralize.to_sym}_list".to_sym
      @breadcrumbs = {
          home: {},
          :"#{params[:event_type].pluralize}_list" => {
              title: I18n.t("layout.breadcrumbs.#{params[:event_type].pluralize}_list"),
              link: {
                  url: send("#{@events_list_key}_path")
              }
          },
          event_item: {
              title: @event.name,
              link: {
                  url: send("#{@event.event_type}_item_path", item: @event.url_fragment, tags: @event.tags.join('-'))
              }
          }
      }

      @page = @event

      set_page_metadata(@page)
      resource = @event

      #@meta_keywords = resource.event_tags.map(&:name).select{|t| t.present? }.uniq.join(',') if resource.respond_to?(:event_tags) && @page_metadata.try{|m| m.meta_keywords}.blank?
    end


    text = ""
    if @page_locale_links.many?
      @page_locale_links.each_pair do |locale, url|
        text += "<a href=\"#{url}\">#{locale}</a><br/>"
      end
    end



    #render inline: text
  end

  def list
    max_events_count = 10

    @breadcrumbs = {
        home: {},
        events_list: {
            title: I18n.t("layout.breadcrumbs.#{params[:route_name]}"),
            link: {
                url: send("#{params[:route_name]}_path")
            }
        }
    }

    params_tag_slug = params[:tag]

    available_tags = EventTag.all

    if params_tag_slug
      selected_event_tag = available_tags.where(url_fragment: params_tag_slug)
      if selected_event_tag.count > 0
        selected_event_tag = selected_event_tag.first
      else
        selected_event_tag = 0
      end
    else
      selected_event_tag = 0
    end

    @event_tags = EventTag.available_tags

    if selected_event_tag == 0
      #@events = Event.all.limit(max_events_count)
      @events = Event.send(params[:event_type].pluralize).published#.order('id desc')

    else
      #@events = selected_event_tag.events.limit(max_events_count)
      @events = selected_event_tag.events.published
      @selected_event_tag = selected_event_tag
      @event_tags = @event_tags.where.not(id: selected_event_tag.id)
    end



    params_page = params[:page]
    if !params_page
      params_page = 1
    end

    @events = @events.order('start_date desc')

    @paginated_events =  @events.paginate(page: params_page, per_page: 10)

    if ajax?
      events_html = render_to_string template: 'events/_list_item', layout: false, locals: { events: @paginated_events }
      #html_source = render_to_string template: 'devise/event_subscriptions/unsubscribe_form.html'
      data = { html: events_html }
      render json: data
    end

    @page = Pages.const_get("#{params[:event_type].capitalize.pluralize}List").first

    set_page_metadata(@page)

  end

  def tag
    render template: 'events/list'
  end


  def register_on_event_get
    find_event

    # if !user_signed_in?
    #   render template: "events/registration_form"
    # end

    render template: "devise/event_subscriptions/new"
  end

  def history
    if user_signed_in?
      @events = current_user.events.send(params[:event_type].pluralize)
      @events_history = true

      events_per_page = 10


      params_page = params[:page]
      @paginated_events = @events.paginate(page: params_page, per_page: events_per_page)

      @breadcrumbs = {
          home: {},
          dashboard: {
              title: "Особистий кабінет",
              link: {
                  url: edit_user_registration_path
              }
          }
      }

      if ajax?
        events_html = render_to_string template: 'events/_list_item', layout: false, locals: { events: @paginated_events }
        #html_source = render_to_string template: 'devise/event_subscriptions/unsubscribe_form.html'
        data = { html: events_html }
        render inline: "#{data.to_json}"
      end



    else
      redirect_to new_user_session_path
    end
  end

  def enable_event_subscription
    event_subscription_id = params[:event_subscription_id]
    enabled = params[:enabled] == 'true'
    disabled = !enabled
    es = EventSubscription.find(event_subscription_id.to_i)
    es.disabled = disabled
    saved = es.save
    render inline: { saved: saved, enabled: enabled }.to_json
  end

  def archive_event_subscription
    event_subscription_id = params[:event_subscription_id]
    archived = params[:archived] == "true"
    unarchived = !archived
    es = EventSubscription.find(event_subscription_id.to_i)
    es.archived_at = archived ? DateTime.now : nil
    saved = es.save
    render inline: { saved: saved, archived: archived }.to_json
  end
end
