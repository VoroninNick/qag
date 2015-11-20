#$("body").on "swipedown swipeup", (e)->
#  console.log "type: ", e.type

$(document).on "ready", ()->
  $('#page-sections').fullpage(
    sectionSelector: ".page-section"
    slideSelector: false
  );