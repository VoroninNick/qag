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

var $body = $('#body')
var $body_inner = $('#body-inner')

// $new_user_session_popup_wrapper.on('content_loaded', function(){
//     console.log('$new_user_session_popup.on')
//     var $flag = $new_user_session_popup_wrapper.find('input.modal-flag')

//     var $body_children = $body.children()
//     var $flags = $body_children.filter('input.flag')

//     $flag.insertBefore($body_inner)

// })

$('div.async-loader').on('content_loaded', function(){
    var $container = $(this)
    var input_id = $container.attr('data-input-id')
    var input_name = 'focus'
    var input_class = 'flag modal-flag'

    var $input = $('<input id="'+input_id+'" name="'+input_name+'" type="radio" class="'+input_class+'" />')
    $input.insertBefore($body_inner)
})


var $new_user_registration_popup_wrapper = $('#new_user_registration-popup-wrapper')
var $new_user_registration_popup = $new_user_registration_popup_wrapper.find('.popup')


//$new_user_registration_popup_wrapper.on('content_loaded', function(){
    //console.log('$new_user_registration_popup.on')
//    var $flag = $new_user_registration_popup_wrapper.find('input.modal-flag')
    //var $body_children = $body.children()
    //var $flags = $body_children.filter('input.flag')

//    $flag.insertBefore($body_inner)
//})

var $popups_wrapper = $('#modal-windows-wrapper')
console.log('popups_wrapper: '+$popups_wrapper.length)
$popups_wrapper.on('click', 'a.link-to-input', function(e){
    e.preventDefault()
    var $link = $(this)
    var data_input_id = $link.attr('data-input')
    var $required_input = $(data_input_id)
    var flag_name = $required_input.attr('name')
    var $flags = $('input[name='+flag_name+']')
    var $active_input = $flags.filter(':checked')

    $active_input.prop('checked', false)
    $required_input.prop('checked', true)


    //var $sender = $(this)
    //var $target_popup = $($sender.attr('data-popup'))
    //var $flags = $('input[name=focus]')
    //$active_flag = $flags.filter(':checked')
    //$required_flag = $('#devise_registrations-new-get-flag')

    //$active_flag.prop('checked', false)
    //$required_flag.prop('checked', true)




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




//
//
//
//
//
