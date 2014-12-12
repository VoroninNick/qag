not_saved_valid_changes_class = 'not-saved-valid-changes'
form_not_saved_valid_changes_class = 'form-not-saved-valid-changes'
has_no_unsaved_changes = 'has-no-unsaved-changes'
dashboard_profile_column_id = 'dashboard-profile-column'
$('#dashboard-content form.simple_form#edit_user').each(function(){
    $.fn.save_field = function(){
        var $input = $(this)
        var $input_wrapper = $input.parent()
        var attribute_name = $input_wrapper.attr('data-attribute-name')
        console.log('attr: ', attribute_name)
        var input_value = $input.val()
        var url = "/my/dashboard/account/settings/" + attribute_name
        console.log('url: ', url)
        $.ajax({
            type: 'post',
            dataType: 'json',
            data: { value: input_value },
            url: url,
            complete: function( jqXHR, textStatus){
                var response_text = jqXHR.responseText
                if(textStatus == 'success'){
                    var data = $.parseJSON(response_text)
                    if(data['saved'] == true){
                        var input_saves_count = $input_wrapper.data('saves_count')
                        //var new_saves_count =
                        $input_wrapper.data('saves_count', (input_saves_count+1) )
                        $input_wrapper.data('last-valid-saved-value', input_value)
                        $input_wrapper.addClass(has_no_unsaved_changes).removeClass(not_saved_valid_changes_class)
                        $input.trigger('dataSaved')

                    }
                }
            }
        })
    }



    $.fn.check_unsaved_changes = function(){
        var $input = $(this)
        var $input_wrapper = $input.parent()
        var input_value = $input.val()
        var last_valid_saved_value = $input_wrapper.data('last-valid-saved-value')
        //var last_changes_not_saved = last_valid_saved_value == undefined || last_valid_saved_value != input_value
        var initial_value = $input_wrapper.data('initial_value')
        var saves_count = $input_wrapper.data('saves_count')

        var has_changes = saves_count == 0 ? (initial_value != input_value) : (last_valid_saved_value != input_value)

        return has_changes
    }

    var $form = $(this)
    $form.addClass(modeViewClass)
    var $form_input_wrappers = $form.find('.input')

    $form_input_wrappers.each(function(){
        var $input_wrapper = $(this)
        var $input = $input_wrapper.find('input')
        var input_value = $input.val()
        $input_wrapper.append('<div class="js-trigger button save-field-button"></div>')
        $input_wrapper.data('saves_count', 0)
        $input_wrapper.data('initial_value', input_value)


    })

    $form.find('input#user_contact_phone').mask("+99 (999) 999 99 99", { completed: function(){

    }
    })

    $form.on('focusin focusout click contentChanged change bufferWrited dataSaved', ['input', '.js-trigger'].join(','), function(event){

        var $this = $(this)
        var $form = $this.closest('form')
        if(event.type == 'focusin'){
            event.preventDefault()
            if($this.get(0).tagName.toLowerCase() == 'input' ){
                var $input = $this
                var $input_wrap = $input.closest('div.input')
                $input_wrap.addClass('focus')
            }
        }

        else if(event.type == 'focusout'){
            event.preventDefault()
            if($this.get(0).tagName.toLowerCase() == 'input' ){
                var $input = $this
                var $input_wrap = $input.closest('div.input')
                $input_wrap.removeClass('focus')
            }
        }

        else if(event.type == 'click'){
            if($this.hasClass('js-trigger')){
                event.preventDefault()
                var $js_trigger = $this
                if($js_trigger.hasClass(modeClass)){
                    if($form.hasClass(modeViewClass)){
                        $form.removeClass(modeViewClass).addClass(modeEditClass)
                        var $input_wrappers = $form.find('.input.'+not_saved_valid_changes_class)
                        $input_wrappers.each(function(){
                            var $input_wrapper = $(this)
                            var $input = $input_wrapper.find('input')
                            var saves_count = $input_wrapper.data('saves_count')
                            var initial_value = $input_wrapper.data('initial_value')
                            if(saves_count == 0){
                                $input.val(initial_value)
                            }
                            else{
                                var last_valid_saved_value = $input_wrapper.data('last-valid-saved-value')
                                $input.val(last_valid_saved_value)
                            }

                            $input_wrapper.addClass(has_no_unsaved_changes).removeClass(not_saved_valid_changes_class)
                        })
                    }
                    else{
                        $form.removeClass(modeEditClass).addClass(modeViewClass)
                    }
                }
                else if($js_trigger.hasClass('save-field-button')){
                    var $input_wrapper = $js_trigger.closest('.input')
                    var $input = $input_wrapper.children().filter('input')
                    $input.save_field()
                }
                else if($js_trigger.hasClass('cancel-changes')){

                    var $unsaved_input_wrappers = $form.find('.input.'+not_saved_valid_changes_class)
                    var do_cancel = $unsaved_input_wrappers.length == 0 || confirm('Зміни будуть втрачені')
                    if(do_cancel ){
                        $form.removeClass(modeEditClass).addClass(modeViewClass)
                        $unsaved_input_wrappers.each(function(){
                            var $input_wrapper = $(this)
                            var $input = $input_wrapper.find('input')
                            var saves_count = $input_wrapper.data('saves_count')
                            var initial_value = $input_wrapper.data('initial_value')
                            if(saves_count == 0){
                                $input.val(initial_value)
                            }
                            else{
                                var last_valid_saved_value = $input_wrapper.data('last-valid-saved-value')
                                $input.val(last_valid_saved_value)
                            }

                            $input_wrapper.addClass(has_no_unsaved_changes).removeClass(not_saved_valid_changes_class)
                        })
                    }
                }
                else if($js_trigger.hasClass('change-password-link')){
                    var url = $js_trigger.attr('href')
                    $.ajax({
                        url: url,
                        type: 'get',
                        dataType: 'json',
                        data: { ajax: true },
                        complete: function(jqXHR, textStatus){
                            var response_text = jqXHR.responseText
                            if(textStatus == 'success') {
                                var data = $.parseJSON(response_text)
                                var $response_html = ''
                                if(data.hasOwnProperty('html')){
                                    var response_html = data['html']
                                    console.log('has html')
                                    $response_html = $.parseHTML(response_html)

                                    var $dashboard_profile_column = $('#'+dashboard_profile_column_id)
                                    $dashboard_profile_column.addClass('view-change-password').removeClass('view-personal-data')

                                    $dashboard_profile_column.append($response_html)

                                }
                            }
                        }
                    })
                }
            }
        }
        else if(event.type == 'contentChanged'){
            event.preventDefault()
            //alert('contentChanged')
            var $input = $(this)
            var $input_wrapper = $input.parent()
            var validation_options_string = $input_wrapper.attr('data-validate') || ''
            var validation_options = validation_options_string.split(' ')
            var field_errors = []
            var field_value = $input.val()
            var required = validation_options.indexOf('required') >= 0
            var empty = field_value.length == 0
            if(required && empty) {
                field_errors.push( { class: 'empty' } )
            }
            else{
                if(validation_options.indexOf('first_name') >= 0){
                    if(!field_value.match(regexes['first_name'])){
                        field_errors.push( { class: 'invalid' } )
                    }
                }
                else if(validation_options.indexOf('last_name') >= 0){
                    if(!field_value.match(regexes['last_name'])){
                        field_errors.push( { class: 'invalid' } )
                    }
                }
                else if(validation_options.indexOf('email') >= 0){
                    if(!field_value.match(regexes['email'])){
                        field_errors.push( { class: 'invalid' } )
                    }
                }
                else if(validation_options.indexOf('first_name') >= 0){
                    if(!field_value.match(regexes['first_name'])){
                        field_errors.push( { class: 'invalid' } )
                    }
                }
            }

            //alert(field_errors.join(' ').toString())


            var error_classes = ['error', 'invalid', 'empty']
            if(field_errors.length == 0){
                $input_wrapper.removeClass('invalid error empty').addClass('valid')
                //var last_valid_saved_value = $input_wrapper.data('last-valid-saved-value')
                //var saves_count = $input_wrapper.data('saves_count')
                //var initial_value = $input_wrapper.data('initial_value')
                //var last_changes_not_saved = last_valid_saved_value == undefined || last_valid_saved_value != field_value

                //var has_changes = saves_count == 0 ? (initial_value != field_value) : (last_valid_saved_value != field_value)
                var has_changes = $input.check_unsaved_changes()
                if(has_changes){
                    $input_wrapper.addClass(not_saved_valid_changes_class).removeClass(has_no_unsaved_changes)
                }
                else{
                    $input_wrapper.addClass(has_no_unsaved_changes).removeClass(not_saved_valid_changes_class)
                }

            }
            else{


                var classes_to_remove = ['valid', not_saved_valid_changes_class]
                var classes_to_add = ['error']
                if(!empty){
                    classes_to_remove.push('empty')
                    classes_to_add.push('invalid')
                }
                else{

                    classes_to_add.push('empty')
                    classes_to_remove.push('invalid')
                }
                //alert('add: '+classes_to_add.join(' ') + '\nremove: ' + classes_to_remove.join(' '))
                //CLASSES_TO_REMOVE = classes_to_remove
                //CLASSES_TO_ADD = classes_to_add
                //INPUT_WRAPPER = $input_wrapper
                $input_wrapper.removeClass(classes_to_remove.join(' ')).addClass(classes_to_add.join(' '))
            }


            //else{
            //    //field_errors += ''
            //    field_errors.push( { class: 'empty' } )
            //}
        }
        else if(event.type == 'change'){
            //alert('hello')

        }
        else if(event.type == 'bufferWrited'){
            //alert('bufferWrited')
            var $input = $(this)
            var input_value = $input.val()
            //console.log('bufferWrited: val: ', input_value)
            var valid = input_value.indexOf('_') < 0
            var $input_wrapper = $input.parent()
            var wasValid = $input_wrapper.hasClass(not_saved_valid_changes_class)

            if(valid){
                //var $input = $(this);
                var $input_wrapper = $input.parent()
                //var saves_count = $input_wrapper.data('saves_count');
                //var input_value = $input.val()

                //abcd
                var has_changes = $input.check_unsaved_changes()
                if(has_changes){
                    $input_wrapper.addClass(not_saved_valid_changes_class).removeClass(has_no_unsaved_changes)
                }
                else{
                    $input_wrapper.addClass(has_no_unsaved_changes).removeClass(not_saved_valid_changes_class)
                }
            }
            else if(wasValid){
                $input_wrapper.addClass(has_no_unsaved_changes).removeClass(not_saved_valid_changes_class)
            }
        }
        else if(event.type == 'dataSaved'){
            var $input = $(this)
            var $input_wrapper = $input.parent()
            var last_valid_saved_value = $input_wrapper.data('last-valid-saved-value')
            $input.val(last_valid_saved_value)
            //alert('dataSaved')
        }

    })

})