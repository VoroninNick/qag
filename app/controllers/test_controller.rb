class TestController < ApplicationController
  def index
    @image_url = MainSliderSlide.last.background.url(:banner)
  end

  def rendering
    
  end
end
