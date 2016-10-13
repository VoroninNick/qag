var $fixed_header_top_container = $('#fixed-header-top-container')
var $events_list_banner_image_wrapper = $('.events-list-banner-image-wrapper')

if($events_list_banner_image_wrapper.length > 0) {
    var $header_menu_button_inner = $('#header-menu-button-label')
    var min_scroll_top = $events_list_banner_image_wrapper.offset().top + $events_list_banner_image_wrapper.height() - 30;
    $(window).scroll(function () {
        var $document = $(document)
        var scroll_top = $document.scrollTop()
        var current_scoll_at_top = $window.scrollTop() <= $fixed_header_top_container.height()
        if (scroll_top >= min_scroll_top && current_scoll_at_top) {
            $header_menu_button_inner.addClass('blue')

        }
        else {
            $header_menu_button_inner.removeClass('blue')
        }
    })

    var $events_list = $('#events-list')
    var $header_menu_button = $('#header-menu-button')
    $events_list.on('mouseover', '.list-item', function () {
        var $this = $(this)
        var event_top = $this.offset().top;
        var event_height = $this.height()
        var event_bottom = event_top + event_height
        var header_menu_button_top = $header_menu_button.offset().top
        var header_menu_button_bottom = header_menu_button_top + $header_menu_button.height()

        if ((header_menu_button_bottom >= event_top && header_menu_button_top <= event_bottom) || $fixed_header_top_container.hasClass('visible')) {
            $header_menu_button_inner.removeClass('blue')
        }
        else {
            $header_menu_button_inner.addClass('blue')
        }
    })
}

$.fn.init_images_carousel = function() {

    var $images_carousel = $(this)

    $images_carousel.each(function (index) {

        var $carousel = $(this)
        $carousel.attr('data-carousel-index', '' + index)
        XXX = $carousel
        var $image_links = $carousel.find('a.hover-expired-event-images-carousel-ul-li-a')
        $image_links.attr('rel', 'group-' + index)
        $image_links.attr('data-fancybox-group', 'group-' + index)
        $image_links.fancybox({
            width: '100%',
            scrolling   : 'hidden',
            helpers: {
                overlay: {
                    locked: true
                },
                title: {
                    type: "outside"
                },

                thumbs: {
                    width: 75,
                    height: 50
                }
            }
        })
        //$carousel

        $carousel.owlCarousel({
            items: 6,
            navigation: false,
            pagination: true,
            lazyLoad: true
        })

    })

};

var $event_list_expired_image_carousels = $('.'+event_list_item_images_carousel_class)
$event_list_expired_image_carousels.init_images_carousel()


var $event_item_images = $('#event-item-page-event-info-column #event-item-images .content a')
$event_item_images.attr('rel', 'group').attr('data-fancybox-group', 'group')
$event_item_images.fancybox({
    width: '100%',
    scrolling   : 'hidden',
    helpers: {
        overlay: {
            locked: true
        },
        title: {
            type: "outside"
        },

        thumbs: {
            width: 75,
            height: 50
        }
    }
})

$('a#more-images.js-trigger').on('click', function(){
    $event_item_images.first().trigger('click')
})