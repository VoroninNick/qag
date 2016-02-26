$("#feedback-form").on "submit", (e)->
  e.preventDefault()
  alert("hello")


  $form = $(this)
  $button = $form.find("button")
  classes = {
    progress_bar_moving_bg: "progress-bar-moving-bg"
  }
  $button.addClass(classes.progress_bar_moving_bg)
  $form.ajaxSubmit(
    success: (data)->
      html = data
      $list = $("#events-list")
      $list.append(html)
      $button.removeClass(classes.progress_bar_moving_bg)
      $form.find("textarea").val("")

  )