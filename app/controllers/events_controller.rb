class EventsController < ApplicationController
  def item
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
