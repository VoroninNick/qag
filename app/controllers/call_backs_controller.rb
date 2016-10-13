class CallBacksController < ApplicationController
  def new
    user_fields = current_user.try{|u| {contact_phone: u.contact_phone, first_name: u.first_name, last_name: u.last_name} } || {}

    @call_back = CallBack.new(user_fields)
    render layout: "modal_layout"
  end

  def create
    call_back_params = (params[:call_back] || {}).merge(user_id: current_user.try(:id))
    @call_back = CallBack.create(call_back_params)

    html_source = render_to_string template: "call_backs/create"
    data = {controller: "call_backs", action: "new", html: html_source  }

    render inline: "#{data.to_json}"


  end
end