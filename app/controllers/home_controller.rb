class HomeController < ApplicationController
  def index

   # if params.include?(:featured_events) && params.include?(:ajax)
   #   @featured_events_json = featured_events
   #   render inline: @featured_events_json

   # else

    @home_page = HomePage.first
    @main_slider_slides = @home_page.main_slider_slides.where(published: true)

    @featured_events = Event.where(published: true).limit(7)
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
