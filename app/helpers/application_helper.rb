module ApplicationHelper
  def stub_image_link(width = 420, height = 350, text = 'item 1')
    image_url = "http://placehold.it/#{width}x#{height}&text=#{text}"
    image_url
  end

  def stub_image(width = 420, height = 350, text = 'item 1', options = {})
    image_url = stub_image_link
    options[:src] = image_url
    output = "<img "
    options.each_pair do |key, value|
      output += "#{key}='#{value}' "
    end
    output += "/>"
    output.html_safe
  end
end
