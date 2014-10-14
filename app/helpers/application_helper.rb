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

  def self.js_embedded_svg filename, options={}
    file = File.read(Rails.root.join('app', 'assets', 'images', filename))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    source = svg.to_html
    minimized_source = source
    minimized_source = minimized_source.remove("\r")
    minimized_source = minimized_source.remove("\t")
    minimized_source = minimized_source.remove("\n")
    minimized_source
  end

  def embedded_svg_from_assets filename, options = {}
    embedded_svg("/app/assets/images/#{filename}", options)
  end

  def embedded_svg_from_public filename, options = {}
    embedded_svg("/public/#{filename}", options)
  end

  def embedded_svg filename, options={}
    embedded_svg_from_absolute_path(Rails.root.to_s + filename.to_s, options)
  end

  def embedded_svg_from_absolute_path(filename, options = {})
    file = File.read(filename.to_s)
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] = options[:class]
    end
    doc.to_html.html_safe
  end
end
