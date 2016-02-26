$(".dashboard-profile-icon").on "click", ()->
  $dashboard_profile_icon = $(this)
  avatar_exists = $dashboard_profile_icon.hasClass("avatar-exists")
  #if !avatar_exists
  #  $("#avatar-file").trigger("click")
  $avatar_popup = $("#avatar-popup")
  showPopup.apply($avatar_popup)

avatar_popup_loading = false

$("#avatar-file").on "change", ()->
  #alert("hi")
  Cropper.fileSelectHandler.apply(this)

$("#dashboard-content").on "submit", "#avatar-form", ()->
  return Cropper.checkForm()




#
#  if !$avatar_popup.length && !avatar_popup_loading
#    avatar_popup_loading = true
#    $.ajax({
#      url: "/edit_avatar?ajax=true"
#      type: "get"
#      success: ()->
#
#    })
#
