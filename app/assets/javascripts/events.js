//var initializeEventsList = function() {
////    $('html.controller-events.action-list').each(function () {
////        var $page = $(this)
////
////        var $tags_select = $page.find('#tag-dropdown-select')
////
////        $tags_select.selectize({})
////    })
//
////    $search_abs_row_wrapper = $('#search-abs-row-wrapper')
////
//
//
//    // ========================================
//    // ----------------------------------------
//    // initialize events
//    // ----------------------------------------
//    // ========================================
//
//    var initialize_events = function() {
//
//        var $events_list = $('#events-list')
//
//        var $uninitialized_events = $events_list.find('div.events-list-event:not(.initialized)')
//
//        var start_index = $uninitialized_events.first().index()
//        var end_index = $uninitialized_events.last().index()
//        var new_events = []
//
//        $uninitialized_events.each(function () {
//
//            var $event = $(this)
//            var $new_event = $('<div class="' + $event.attr('class') + '"></div>')
//            var $back = $('<div class="events-list-event-back"></div>')
//            var $back_row = $('<div class="event-back-row row"></div>')
//            $back.append($back_row)
//            var $front = $('<div class="events-list-event-front"></div>')
//            var $front_row = $('<div class="event-front-row row"></div>')
//            $front.append($front_row)
//
//            if (!$new_event.hasClass('expired-event')) {
//                var $event_title = $event.find('div.event-title')
//                var $event_title_clone = $event_title.clone()
//                $back_row.append($event_title_clone)
//
//                var $hover_date_and_participants = $event.find('div.hover-event-date-range-and-participants')
//                var $back_date_and_participants = $hover_date_and_participants.clone()
//                $back_row.append($back_date_and_participants)
//
//                var $register_button = $event.find('div.event-link-and-register-button')
//                var $register_button_clone = $register_button.clone()
//                $back_row.append($register_button_clone)
//
//
//                var $image_and_info = $event.find('div.image-and-info')
//                var $image_and_info_clone = $image_and_info.clone()
//                $front_row.append($image_and_info_clone)
//
//
//                var $description = $event.find('div.description')
//                $description.find('div.event-link-and-register-button').remove()
//                $front_row.append($description)
//            }
//
//            $new_event.append($back)
//
//            $new_event.append($front)
//
//            //$new_event.find('div.events-list-event-row').remove()
//
//            $new_event.addClass('initialized')
//
//            new_events.push($new_event)
//        })
//
//        $uninitialized_events.remove()
//        if ($events_list.children().length == 0) {
//            $events_list.append(new_events)
//            //NEW_EVENTS = new_events
//        }
//        else {
//            var $prev_event = $events_list.find('div.events-list-event:eq(' + (start_index - 1) + ')')
//            $(new_events).insertAfter($prev_event)
//        }
//
//    }
//
//    //initialize_events()
//
//
//
//
//
//
//
//    var $events_list_banner_image_wrapper = $('#events-list-banner-image-wrapper')
//
//    var $header_menu_button_inner = $('#header-menu-button-inner')
//    var min_scroll_top = $events_list_banner_image_wrapper.offset().top + $events_list_banner_image_wrapper.height() - 30;
//    $(window).scroll(function(){
//        //var min_scroll_top = 220
//        var $document = $(document)
//        var scroll_top = $document.scrollTop()
//        if(scroll_top >= min_scroll_top){
//            //$search_abs_row_wrapper.addClass('fixed')
//            $header_menu_button_inner.addClass('blue')
//        }
//        else{
//            //$search_abs_row_wrapper.removeClass('fixed')
//            $header_menu_button_inner.removeClass('blue')
//        }
//    })
//
//    var $events_list = $('#events-list')
//    var $header_menu_button = $('#header-menu-button')
//    $events_list.on('mouseover', '.events-list-event', function(){
//        var $this = $(this)
//        var event_top = $this.offset().top;
//        var event_height = $this.height()
//        var  event_bottom = event_top + event_height
//        //var scrollTop = $(document).scrollTop()
//        var header_menu_button_top = $header_menu_button.offset().top
//        var header_menu_button_bottom = header_menu_button_top + $header_menu_button.height()
//
//        if(header_menu_button_bottom >= event_top && header_menu_button_top <= event_bottom){
//            $header_menu_button_inner.removeClass('blue')
//        }
//        else{
//            $header_menu_button_inner.addClass('blue')
//        }
//    })
//}
//
//$(document).on('page:load ready', function(){
//    var $list = $('#events-list')
//    if($list.length > 0){
//        //initializeEventsList()
//    }
//})
//
////if()
////initializeEventsList()


var $event_list_expired_image_carousels = $('.'+event_list_item_images_carousel_class)



$event_list_expired_image_carousels.each(function(index){

    var $carousel = $(this)
    $carousel.attr('data-carousel-index', ''+index)
    var $image_links= $carousel.find('a.hover-expired-event-images-carousel-ul-li-a')
    $image_links.attr('rel', 'group-'+index)
    $image_links.attr('data-fancybox-group', 'group-'+index)
    $image_links.fancybox({})

})

$event_list_expired_image_carousels.owlCarousel({
    items: 6,
    navigation : true,
    lazyLoad : true
})