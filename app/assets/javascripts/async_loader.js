(function ($) {



    var partial_paths = []
    var partials = []
    var $partial_containers = $('div.async-partial-loader')
    $partial_containers.each(function () {
        var $container = $(this)
        var path = $container.attr('data-path')
        partial_paths.push(path)
        partials.push({container: $container, path: path})

    })

    $.ajax('?load_partial=' + partial_paths.join(),
        { dataType: 'json', type: 'GET',
            success: function (data) {
                var $data = $(data)
                var response_data = $data
                $.each(response_data, function(index, partial){
                    PARTIAL = partial
                    $partial_containers.eq(index).append(partial['partial'])

                })

                //$container.append(partial_source)
            }
        })

})(jQuery);



var loadControllerAction = function(){
    var $partial_containers = $('div.async-loader')
    $partial_containers.each(function () {
        var $container = $(this)
        //var path = $container.attr('data-path')
        //partial_paths.push(path)
        //partials.push({container: $container, path: path})

        var url = $container.attr('data-url')


        $.ajax( url+'?modal=true',
            { dataType: 'text', type: 'GET',
                success: function (data) {
                    var $data = $(data)
                    var response_data = $data
                    var html = $data.get()

                    CONTENT = data
//                    $.each(response_data, function (index, partial) {
//                        PARTIAL = partial
//                        $partial_containers.eq(index).append(partial['partial'])
//
//                    })
                    $container.append(data)

                    $container.addClass('content-loaded')

                    $container.trigger('content_loaded')

                    //$container.append(partial_source)
                }
            })
    })
}

loadControllerAction()