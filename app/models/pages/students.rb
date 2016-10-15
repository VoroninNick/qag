class Pages::Students < Cms::Page
  has_html_block :students_text

  has_cache
  def url(*args)
    "/students"
  end
end