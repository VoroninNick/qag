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
//= require jquery/dist/jquery.min
//= require jquery_ujs
//= require misc
//= require interpolate
//= require jquery.manipulate_classes
//= require owl_carousel_1_full.min
// require event.simulate
//= require jquery.maskedinput
//= require jquery.content_changed
//= require fancybox

//= require jquery-touch-events/src/1.0.1/jquery.mobile-events


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
//= require popup
//= require test_map
//= require home
//= require contact
//= require events
// require render
// require initializers/layout
// require initializer




//= require fast_code/layout
//= require fast_code/dashboard

//$(function(){ $(document).foundation(); });




$(document).on('page:load', function(){
    if(window.location.pathname == '' || window.location.pathname == '/'){
        $('#html').addClass('controller-home action-index');
    }
    else{
        $('#html').removeClass('controller-home action-index');
    }

})

