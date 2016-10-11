class CallBacksController < ApplicationController
  def new
    @call_back = CallBack.new
    render layout: "modal_layout"
  end

  def create
    @call_back = CallBack.create(params[:call_back])
    render inline: ""
  end
end