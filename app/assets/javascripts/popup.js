//$('.popup-link').on('click', function(){
//    var $popup_link = $(this)
//
//})


var $header_menu_user_icon = $('#header-menu-user')
var $new_user_session_popup_wrapper = $('#new_user_session-popup-wrapper')
var $new_user_session_popup = $new_user_session_popup_wrapper.find('.popup')

var str = $("<div />").append($header_menu_user_icon.clone()).html();
var rebuilded_str = str.replace('<a', '<label').replace('</a', '</label')
$header_menu_user_icon.replaceWith(rebuilded_str)

$new_user_session_popup_wrapper.on('content_loaded', function(){
    console.log('$new_user_session_popup.on')
    var $flag = $new_user_session_popup_wrapper.find('input.modal-flag')
    var $body = $('#body')
    var $body_inner = $('#body-inner')
    var $body_children = $body.children()
    var $flags = $body_children.filter('input.flag')

//    if( $flags.length > 0 ){
//        $flag.insertAfter($('#body').find('input.flag').last())
//    }
//    else{
//        $flag.insertBefore($body_children.first())
//    }
    $flag.insertBefore($body_inner)

})


//$header_menu_user_icon.on('click', function(){
//    console.log('hello')
//    var show_popup = function(){
//        $new_user_session_popup = $new_user_session_popup_wrapper.find('.popup')
//        $new_user_session_popup.addClass('active')
//    }
//    if($new_user_session_popup_wrapper.hasClass('content-loaded')){
//
//        show_popup()
//    }
//    else{
//        $new_user_session_popup.on('content_loaded', show_popup())
//    }
//
//})