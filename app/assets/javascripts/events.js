var initializeEventsList = function() {
//    $('html.controller-events.action-list').each(function () {
//        var $page = $(this)
//
//        var $tags_select = $page.find('#tag-dropdown-select')
//
//        $tags_select.selectize({})
//    })

//    $search_abs_row_wrapper = $('#search-abs-row-wrapper')
//

    var $events_list_banner_image_wrapper = $('#events-list-banner-image-wrapper')

    var $header_menu_button_inner = $('#header-menu-button-inner')
    var min_scroll_top = $events_list_banner_image_wrapper.offset().top + $events_list_banner_image_wrapper.height() - 30;
    $(window).scroll(function(){
        //var min_scroll_top = 220
        var $document = $(document)
        var scroll_top = $document.scrollTop()
        if(scroll_top >= min_scroll_top){
            //$search_abs_row_wrapper.addClass('fixed')
            $header_menu_button_inner.addClass('blue')
        }
        else{
            //$search_abs_row_wrapper.removeClass('fixed')
            $header_menu_button_inner.removeClass('blue')
        }
    })

    var $events_list = $('#events-list')
    var $header_menu_button = $('#header-menu-button')
    $events_list.on('mouseover', '.events-list-event', function(){
        var $this = $(this)
        var event_top = $this.offset().top;
        var event_height = $this.height()
        var  event_bottom = event_top + event_height
        //var scrollTop = $(document).scrollTop()
        var header_menu_button_top = $header_menu_button.offset().top
        var header_menu_button_bottom = header_menu_button_top + $header_menu_button.height()

        if(header_menu_button_bottom >= event_top && header_menu_button_top <= event_bottom){
            $header_menu_button_inner.removeClass('blue')
        }
        else{
            $header_menu_button_inner.addClass('blue')
        }
    })
}

$(document).on('page:load', initializeEventsList)

initializeEventsList()