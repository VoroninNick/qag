// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require misc
//= require interpolate
//= require jquery.manipulate_classes
//= require owl_carousel_1_full.min
// require event.simulate
//= require jquery.maskedinput
//= require jquery.content_changed
//= require fancybox
//= require jquery_appear/jquery.appear

//= require fullpage.js/jquery.fullPage.min
//= require bxslider-4/dist/jquery.bxslider.min.js

//= require jquery-touch-events/src/1.0.1/jquery.mobile-events

//= require jquery-form/jquery.form

// require tiny_validation
//= require validation
//= require variables
// require translate_functions
// require locales
// require async_loader
//= require jquery.mousewheel.min
//= require grayscale.min
// selectize
// foundation
// require turbolinks
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
// require render
// require initializers/layout
// require initializer




//= require fast_code/layout
//= require fast_code/dashboard
//= require fast_code/feedbacks

//= require Jcrop/js/jquery.Jcrop.min

//= require fast_code/cropper
//= require fast_code/dashboard_avatar


//= require mobile/home_scroll

//$(function(){ $(document).foundation(); });




$(document).on('page:load', function(){
    if(window.location.pathname == '' || window.location.pathname == '/'){
        $('#html').addClass('controller-home action-index');
    }
    else{
        $('#html').removeClass('controller-home action-index');
    }

})

