$(".dashboard-profile-icon").on "click", ()->
  $dashboard_profile_icon = $(this)
  avatar_exists = $dashboard_profile_icon.hasClass("avatar-exists")
  if !avatar_exists
    $("#avatar-file").trigger("click")

avatar_popup_loading = false

$("#avatar-file").on "change", ()->
  alert("hi")

  $avatar_popup = $("#avatar-popup")

#
#  if !$avatar_popup.length && !avatar_popup_loading
#    $.ajax({
#      url: "/edit_avatar?ajax=true"
#      type: "get"
#
#    })
#
