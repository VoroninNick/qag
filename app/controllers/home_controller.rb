class HomeController < ApplicationController
  def index

   # if params.include?(:featured_events) && params.include?(:ajax)
   #   @featured_events_json = featured_events
   #   render inline: @featured_events_json

   # else

    @home_page = HomePage.first
    @main_slider_slides = @home_page.main_slider_slides.where(published: true)


    all_events = Event.where(published: true).order('start_date asc')
    @featured_events = []
    all_events_count = all_events.count

    requested_count = 7
    future_events_limit = requested_count / 2 + 1
    future_events = all_events.where("start_date >= '#{Date.today}'").order('start_date asc').limit(future_events_limit)
    start_number = 0
    if future_events.count == 0
      start_number = all_events_count
    else
      start_id = future_events.first.id
      all_events.where("id = #{start_id}")
      future_events_count = future_events.count


      required_prev_count = (future_events_count > requested_count / 2)? requested_count / 2  : requested_count - future_events_count
      prev_events = all_events.where("start_date < '#{Date.today}'").order('start_date asc').last(required_prev_count)

      @featured_events = prev_events + future_events

    end

    @featured_events_active_event_index = prev_events.count


    @featured_events_timeline_items_count = @featured_events.count
    @featured_events_timeline_pages_count = (((@featured_events_timeline_items_count -7)/3).floor) + 1

    query = "SELECT id, start_date FROM #{Event.table_name} e"
    @event_links = ActiveRecord::Base.connection.execute(query)


    @expired_events = Event.where(published: true).limit(20)


    @about_slides = @home_page.home_about_us_slides

    @home_contact_info = @home_page.home_contact_infos.first

    @home_map_markers = []

    m = {lat: @home_contact_info.map_latitude, lng: @home_contact_info.map_longtitude, address: @home_contact_info.address}
    @home_map_markers.push m


    @home_reviews = Comment.all.includes(:user).limit(6)



    render layout: 'application_foundation'
    #end
  end

  def featured_events
    #respond_to do |format|
      #format.html

        events = Event.where("published='t'").includes(:translations)
        events_arr = []
        events.each_with_index do |e, index|
          if index > 6
            event_obj = { name: e.name, date_range: { start_date: {day:  e.start_date.day, month: e.start_date.month }, end_date: { day: e.end_date.day, month: e.end_date.month } } }
            events_arr.push(events_arr)

          end
        end

        events_arr.to_json


    #end
  end


end
