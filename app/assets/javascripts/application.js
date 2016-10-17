//= require jquery/dist/jquery.min
//= require jquery_ujs
//= require misc
//= require interpolate
//= require jquery.manipulate_classes
//= require owl_carousel_1_full.min

//= require jquery.maskedinput
//= require jquery.content_changed
//= require fancybox
//= require jquery_appear/jquery.appear

//= require fullpage.js/jquery.fullPage.min
//= require bxslider-4/dist/jquery.bxslider.min.js

//= require jquery-touch-events/src/1.0.1/jquery.mobile-events

//= require jquery-form/jquery.form


//= require validation
//= require variables

//= require jquery.mousewheel.min
//= require grayscale.min

//= require rich_marker
//= require _share_popup
//= require _call_back_popup
//= require popup
//= require test_map
//= require home
//= require pages/about
//= require pages/feedbacks
//= require contact
//= require events

//= require fast_code/layout
//= require fast_code/dashboard
//= require fast_code/feedbacks

//= require Jcrop/js/jquery.Jcrop.min

//= require fast_code/cropper
//= require fast_code/dashboard_avatar


//= require mobile/home_scroll




$(document).on('page:load', function(){
    if(window.location.pathname == '' || window.location.pathname == '/'){
        $('#html').addClass('controller-home action-index');
    }
    else{
        $('#html').removeClass('controller-home action-index');
    }

})

