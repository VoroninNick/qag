class HomeController < ApplicationController

  caches_page :index, :event_info

  def index
    @home_page = HomePage.first
    @main_slider_slides = @home_page.main_slider_slides.where(published: true)

    set_page_metadata(@home_page)

    get_events 

    events_per_page = 7

    @prev_events_total = @prev_events.count
    @prev_events_total_pages = (@prev_events_total.to_f / events_per_page).ceil
    @future_events_total = @future_events.count
    @future_events_total_pages = (@future_events_total.to_f / events_per_page).ceil

    @paginated_prev_events = @prev_events.paginate(page: 1, per_page: events_per_page)
    @paginated_future_events = @future_events.paginate(page: 1, per_page: events_per_page)

    @paginated_prev_events_count = events_per_page

    @featured_events_active_event_index = events_per_page

    @featured_events = @paginated_prev_events + @paginated_future_events

    @featured_events_timeline_items_count = @featured_events.count
    @featured_events_timeline_pages_count = (((@featured_events_timeline_items_count -7)/3).floor) + 1



    query = "SELECT id, start_date FROM #{Event.table_name} e"
    @event_links = ActiveRecord::Base.connection.execute(query)


    #@expired_events = Event.where(published: true).limit(20)


    @about_slide = @home_page.home_about_us_slides.first

    @home_contact_info = @home_page.home_contact_infos.first

    @home_map_markers = []

    m = {lat: @home_contact_info.map_latitude, lng: @home_contact_info.map_longtitude, address: @home_contact_info.address}
    @home_map_markers.push m

    @home_reviews = UserFeedback.published.featured.limit(6)

    @page = HomePage.first
  end

  def featured_events
        get_events

        prev_events_required_page = params[:prev_events_page]
        future_events_required_page = params[:future_events_page]

        events_per_page = 7


        paginated_prev_events = @prev_events.paginate(page: prev_events_required_page, per_page: events_per_page)
        paginated_future_events = @future_events.paginate(page: future_events_required_page, per_page: events_per_page)


        prev_events_arr = []
        paginated_prev_events.each do |e|
          event_obj = get_info_for_event(e)
          prev_events_arr.push(event_obj) 
        end

        future_events_arr = []
        paginated_future_events.each do |e|
          event_obj = get_info_for_event(e)
          prev_events_arr.push(event_obj) 
        end

        result = {
          prev_events: prev_events_arr,
          future_events: future_events_arr,
          total_prev_events_count: @prev_events.count,
          total_future_events_count: @future_events.count,
          total_prev_events_pages_count: (@prev_events.count.to_f / events_per_page).ceil,
          total_future_events_pages_count: (@future_events.count.to_f / events_per_page).ceil
        }

        render inline: "#{result.to_json}"
  end

  def get_info_for_event(e)

    

              event_obj = {
           id: e.id,
           name: e.name, 
           date_range: {
             start_date: {
               day: e.start_date.day, 
               month: e.start_date.month, 
               year: e.start_date.year 
             }, 
             end_date: {
               day: e.end_date.day,
               month: e.end_date.month, 
               year: e.end_date.year 
             } 
          },
          short_description: e.short_description,
          participants_count: e.participants_count,
          event_link: event_item_path(item: e.url_fragment, tags: e.tags.join('-')),
          registered: ( user_signed_in? ? ( subscribed_on_event?(e.id) ) : false ),
          image_url: image_or_stub_url(e.avatar, :event_list_small_thumb, 360, 240, "event #{e.id}") 
        }

        if event_obj[:registered]
          event_obj[:unregister_link] = event_unsubscription_form_path(event_id: e.id)
        else
          event_obj[:register_link] = new_event_subscription_path(event_id: e.id)
        end
        event_obj
  end

  def get_events
    @all_events ||= Event.published.includes(:translations)
    @prev_events ||= @all_events.where("start_date < '#{Date.today}'").order('start_date asc')
    @future_events ||= @all_events.where("start_date >= '#{Date.today}'").order('start_date asc')
  end

  def get_all_events
    @all_events ||= Event.published.includes(:translations)
  end

  def future_events_thumbnails
    page = params[:page]
    events_per_page = 7

    start_number = params[:start_number].to_i
    end_number = params[:end_number].to_i

    result_events = []

    @future_events ||= get_all_events.where("start_date >= '#{Date.today}'").order('start_date asc')
    #@paginated_future_events ||= @future_events.paginate(page: page, per_page: events_per_page)
    result_events = @future_events.limit(end_number).last(end_number-start_number+1)


    future_events_html = ''
    result_events.each_with_index do |event, index|
      future_events_html += render_to_string template: 'home/_home_timeline_thumbnail', layout: false, locals: { event: event, index: index, prev: false, future: true, carousel_event_index: (start_number-1+index), loaded: false }
    end

    render inline: future_events_html
  end

  def prev_events_thumbnails
    page = params[:page]
    events_per_page = 7

    start_number = params[:start_number].to_i
    end_number = params[:end_number].to_i

    result_events = []


    @prev_events ||= get_all_events.where("start_date < '#{Date.today}'").order('start_date desc')
    #@paginated_prev_events ||= @prev_events.paginate(page: page, per_page: events_per_page)

    result_events = @prev_events.limit(end_number).last(end_number-start_number+1)
    prev_events_html = ''
    result_events.each_with_index do |event, index|
      prev_events_html += render_to_string template: 'home/_home_timeline_thumbnail', layout: false, locals: { event: event, index: index, prev: true, future: false, carousel_event_index: (start_number+index), loaded: false }
    end

    render inline: prev_events_html
  end

  def event_info
    event_id = params[:event_id]
    if !event_id
      event_ids = params[:event_ids].split(',').map(&:to_i)
    else
      event_ids = event_id
    end

    events = Event.published.where(id: event_ids)
    events_html = ''
    events.each_with_index do |event, index|
      event_html = render_to_string template: 'home/_home_timeline_event_info', layout: false, locals: { event: event, index: index, active: true }
      events_html += event_html
    end

    render inline: events_html
  end
end
