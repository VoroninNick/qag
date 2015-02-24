class DataController < ApplicationController
  before_filter do
    @data = {

    }
  end

  def index
    if params[:featured_events]
      if params[:ajax] == 'true'

      end
    end

    data = get_home_featured_event
    render inline: data.to_json
  end
  def get_home_featured_event
    data = {}

    if params[:direction] == 'both'
      prev_start = params[:prev_start].to_i
      prev_count = params[:prev_count].to_i
      next_start = params[:next_start].to_i
      next_count = params[:next_count].to_i

      prev_event_objects = []
      next_event_objects = []
      data = []

      all_events = Event.where(published: true).order('start_date asc')

      prev_events = all_events.where("start_date < '#{Date.today}'").order('start_date asc')
      requested_prev_events = prev_events[prev_start..(prev_start + prev_count - 1)]
      response_prev_count = requested_prev_events.count
      available_prev_request = prev_events.count > (prev_start + prev_count - 1)

      prev_remaining = prev_events.count - (prev_start + prev_count - 1)
      prev_remaining = 0 if prev_remaining < 0

      next_events = all_events.where("start_date >= '#{Date.today}'").order('start_date asc')
      requested_next_events = next_events[next_start..(next_start + next_count - 1)]
      response_next_count = requested_next_events.count
      available_next_request = next_events.count > (next_start + next_count - 1)

      next_remaining = next_events.count - (next_start + next_count - 1)
      next_remaining = 0 if next_remaining < 0

      requested_prev_events.each_with_index do |e, index|
        obj = { img_src: e.avatar.url(:event_list_small_thumb), name: e.name, short_description: e.short_description, event_link: '#', start_date: e.start_date, end_date: e.end_date, participants_count: e.participants_count, future_event: false, number: prev_start + prev_count - 1 - index }
        prev_event_objects.push obj
      end

      requested_prev_events.each_with_index do |e, index|
        obj = { img_src: e.avatar.url(:event_list_small_thumb), name: e.name, short_description: e.short_description, event_link: '#', start_date: e.start_date, end_date: e.end_date, participants_count: e.participants_count, future_event: false, number: next_start + next_count + index }
        next_event_objects.push obj
      end

      data = {
          prev_events: prev_event_objects,
          next_events: next_event_objects,
          total_count: all_events.count,
          prev_remaining: prev_remaining,
          next_remaining: next_remaining
      }




    end

    data
  end
end