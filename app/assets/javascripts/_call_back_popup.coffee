$("#fixed-call-button").on "click", (e)->
  e.preventDefault()
  $link = $(this)
  url = $link.attr("href")
  $.ajax({
    url: url
    success: (data, textStatus, jqXHR)->
      $("body").append(data)
  })