(function ($) {



    var partial_paths = []
    var partials = []
    var $partial_containers = $('div.async-partial-loader')
    $('div.async-partial-loader').each(function () {
        var $container = $(this)
        var path = $container.attr('data-path')
        partial_paths.push(path)
        partials.push({container: $container, path: path})

    })

    $.ajax('?load_partial=' + partial_paths.join(),
        { dataType: 'json', type: 'GET',
            success: function (data) {
                var $data = $(data)
                var response_data = $data.get(0)
                $.each(response_data, function(index, partial){
                    $partial_containers.eq(index).append(partial['partial'])
                })

                //$container.append(partial_source)
            }
        })

})(jQuery);