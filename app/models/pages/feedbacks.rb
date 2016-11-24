class Pages::Feedbacks < Page
  def url(locale = I18n.locale)
    "/feedbacks"
  end
end