$(document).on "click", ".articles-list-article .expand, .articles-list-article .collapse", ()->
  $button = $(this)
  expand = $button.hasClass("expand")
  $feedback = $button.closest(".articles-list-article")
  $text_block = $feedback.find(".article-short-description")

  if expand
    $feedback.addClass("expanded")
    text_height = $feedback.find(".article-short-description-inner").height()
    $text_block.css(maxHeight: text_height)
  else
    $text_block.css(maxHeight: "")
    $feedback.removeClass("expanded")