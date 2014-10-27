class EventsController < ApplicationController


  def item
    params_item = params[:item]
    @event_ids_rows = Event.find_by_sql("select t.event_id as id from #{Event.translation_class.table_name} t where t.locale='#{I18n.locale}' and t.slug='#{params_item}'")
    @event_ids = []
    @event_ids_rows.each {|e| @event_ids.push e['id']  }
    @events = Event.find(@event_ids)
    @event = (@events.respond_to?(:count) && @events.count > 0)? @events.first : nil

    @event.translations_by_locale.keys.each do |locale|
      I18n.with_locale(locale.to_sym) do
        @page_locale_links[locale.to_sym] = url_for(item: @event.slug, tags: @event.tags.join('-'), locale: locale)
      end

    end


    @breadcrumbs = {
        home: {},
        events_list: {
            title: I18n.t('layout.breadcrumbs.events_list'),
            link: {
                url: events_list_path(locale: I18n.locale)
            }
        },
        event_item: {
            title: @event.name,
            link: {
                url: event_item_path(item: @event.slug, tags: @event.tags.join('-'), locale: I18n.locale)
            }
        }
    }


    text = ""
    @page_locale_links.each_pair do |locale, url|
      text += "<a href=\"#{url}\">#{locale}</a><br/>"
    end

    #render inline: text
  end

  def list
    max_events_count = 10

    @breadcrumbs = {
        home: {},
        events_list: {
            title: I18n.t('layout.breadcrumbs.events_list'),
            link: {
                url: events_list_path
            }
        }
    }

    params_tag_slug = params[:tag]

    available_tags = EventTag.all

    if params_tag_slug
      selected_event_tag = available_tags.where(slug: params_tag_slug)
      if selected_event_tag.count > 0
        selected_event_tag = selected_event_tag.first
      else
        selected_event_tag = 0
      end
    else
      selected_event_tag = 0
    end

    @event_tags = EventTag.all

    if selected_event_tag == 0
      @events = Event.all.limit(max_events_count)


    else
      @events = selected_event_tag.events.limit(max_events_count)
      @selected_event_tag = selected_event_tag
      @event_tags = @event_tags.where("id <> #{selected_event_tag.id}")
    end


  end

  def tag

    render template: 'events/list'
  end
end
