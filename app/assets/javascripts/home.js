// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
$('.controller-home.action-index').each(function(){
  var $page = $(this)
//    $.ajax(
//        {
//            url: '/?featured_events&ajax',
//            type: 'GET',
//            dataType: 'json',
//            success: function(data){
//                var $events_section = $('.home-featured-events-section')
//
//            }
//
//        } )

//    var event = 'onwheel' in document ? 'wheel' : 'onmousewheel' in document ? 'mousewheel' : 'DOMMouseScroll';
//    window.addEventListener(event, function(){
//        console.log('wheel')
//    });

    //$('body').bind('mousewheel', function(e) {
//        if(e.originalEvent.wheelDelta / 120 > 0) {
//            alert('up');
//        } else {
//            alert('down');
//        }

  //      console.log('mousewheel')
  //  });

    counter = 0

    $('body').mousewheel(function(event) {

        if(counter == 0 ) {



            console.log("hello:" + event.deltaX, event.deltaY, event.deltaFactor);

            var $flags = $('.home-page-section-flag')
            var $checked_flag = $flags.filter(':checked')
            var checked_flag_index = $checked_flag.index()
            var checked_section_number = Number.parseInt($checked_flag.attr('data-to'))

            var next_number = 0;
            var min_number = 1;
            var max_number = 6;
            if (event.deltaY > 0)
                next_number = (checked_section_number > min_number) ? checked_section_number - 1 : min_number;
            else {
                next_number = (checked_section_number < max_number) ? checked_section_number + 1 : max_number
            }


            if (checked_section_number != next_number) {
                console.log('checked:' + checked_section_number + '; next: ' + next_number)
                $next_flag = $flags.filter('#home-page-section-flag-from-'+(checked_section_number)+'-to-'+(next_number))
                //$checked_flag.removeAttr('checked')
                //$next_flag.attr('checked', 'checked')
                $checked_flag.prop('checked', false)
                $next_flag.prop('checked', true)


            }
        }
        if(counter == 3)
            counter = 0
        else
            counter++
    });

})


var $home_featured_event_info_slides_row = $('#home-featured-event-info-slides-row')
var $home_featured_events_section = $('#home-featured-events-section')
if($home_featured_event_info_slides_row.length > 0) {
    //$home_featured_event_info_slides_row.



    $home_featured_event_info_slides_row.on('click', '#home-featured-prev-event-arrow, #home-featured-next-event-arrow', function () {
        var $arrow = $(this)
        var arrow = $arrow.get(0)
        var direction = arrow.id == 'home-featured-next-event-arrow'

        var $flags = $home_featured_events_section.find('input.home-featured-events-timeline-flag')
        var flags_count = $flags.length
        var $checked_flag = $flags.filter(':checked')
        var checked_event_number = Number.parseInt($checked_flag.attr('data-event-number'))

        var challenge_event_number = checked_event_number
        if(direction){
            if(checked_event_number < flags_count){
                challenge_event_number++
            }
            else{
                challenge_event_number = 1
            }
        }
        else{
            if(checked_event_number > 1){
                challenge_event_number--
            }
            else{
                challenge_event_number = flags_count
            }
        }

        var $challenge_event = $('#home-featured-events-timeline-flag-' + challenge_event_number)

        $checked_flag.prop('checked', false)
        $challenge_event.prop('checked', true)

        var str_direction = direction? 'next' : 'prev'
        $challenge_event
            .removeClass('prev-arrow-hide-event-animation')
            .removeClass('next-arrow-hide-event-animation')
            .addClass(str_direction + '-arrow-show-event-animation')

        $checked_flag
            .removeClass('prev-arrow-show-event-animation')
            .removeClass('next-arrow-show-event-animation')
            .addClass(str_direction + '-arrow-hide-event-animation')


    })
}