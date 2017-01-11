#$("body").on "swipedown swipeup", (e)->
#  console.log "type: ", e.type


hideHeaderLogo = ()->
  $header_logo = $("#header-logo")
  $header_logo.hide()

showHeaderLogo = ()->
  $header_logo = $("#header-logo")
  $header_logo.show()

addAccentToMenuButton = ()->
  $button = $("#header-menu-button")
  $button.addClass("with-accent")

removeAccentFromMenuButton = ()->
  $button = $("#header-menu-button")
  $button.removeClass("with-accent")


window.init_full_page_and_bxslider = ()->
  $('#page-sections').fullpage(
    sectionSelector: ".page-section"
    slideSelector: false
    onLeave: (index, nextIndex, direction)->
      leavingSection = $(this)

      if nextIndex > 1
        hideHeaderLogo()
        addAccentToMenuButton()

      else
        showHeaderLogo()
        removeAccentFromMenuButton()


  )

  $("#home-slides-ul").bxSlider(
    mode: "fade"
  )

$(document).on "ready", init_full_page_and_bxslider



$(window).on "scroll", ()->
  scroll_top = $("body").scrollTop()
  if window.innerWidth <= 640 && scroll_top > 0
    hideHeaderLogo()
    addAccentToMenuButton()
  else
    showHeaderLogo()
    removeAccentFromMenuButton()

$("body").on "click", "#header-menu-button", ()->
  $body = $("body")
  opened_menu = $body.hasClass("open-menu")
  if $.fn.fullpage
    if  $.fn.fullpage.setMouseWheelScrolling
      $.fn.fullpage.setMouseWheelScrolling(opened_menu)
    if $.fn.fullpage.setAllowScrolling
      $.fn.fullpage.setAllowScrolling(opened_menu)
  $body.toggleClass("open-menu")