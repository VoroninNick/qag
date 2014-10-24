//$('.popup-link').on('click', function(){
//    var $popup_link = $(this)
//
//})


var $header_menu_user_icon = $('#header-menu-user')
var $new_user_session_popup_wrapper = $('#new_user_session-popup-wrapper')
var $new_user_session_popup = $new_user_session_popup_wrapper.find('.popup')

$header_menu_user_icon.on('click', function(){
    console.log('hello')
    var show_popup = function(){
        $new_user_session_popup = $new_user_session_popup_wrapper.find('.popup')
        $new_user_session_popup.addClass('active')
    }
    if($new_user_session_popup_wrapper.hasClass('content-loaded')){

        show_popup()
    }
    else{
        $new_user_session_popup.on('content_loaded', show_popup())
    }

})