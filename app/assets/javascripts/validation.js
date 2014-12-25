regexes = {
    name: /[\wа-яa-z]+/ig,
    first_name: /[\wа-яa-z]+/ig,
    last_name: /[\wа-яa-z]+/ig,
    email: /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
    //password: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/,
    password: /^[a-zA-Z0-9\-\#\_]{8,24}$/
    //phone: /^(+(38))$/
}



function validateData(array){
    for(var i = 0; i< array.length; i++){
        var elem = array[i]

    }
}


(function() {
    $.fn.validate_form = function () {
        var $this = $(this)
        var selected_length = $this.length
        for( var i = 0; i < selected_length; i++ ) {


            var $form = $(this).eq(i)
            var form = $form.get(0)
            if (form.tagName.toLowerCase() == 'form') {

                var $validated_fields = $form.find('[data-validate]')
                var valid = true

                var validated_fields_length = $validated_fields.length

                for (var i = 0; i < validated_fields_length; i++) {
                    var $field = $validated_fields.eq(i)

                    field_validation_options = $field.attr('data-validate').split(' ')
                    var field_validation_options_count = field_validation_options.length

                    var field_value

                    if ($field.hasClass('input')) {
                        var $input = $field.find('input')
                        var input_value = $input.val()
                        field_value = input_value
                    }

                    if (field_validation_options.indexOf('required') >= 0) {
                        if (!field_value || field_value == '') {
                            $field.manipulateClasses(['error'], ['valid'])
                            valid = false
                        }
                        else {
                            $field.manipulateClasses(['valid'], ['error'])
                        }
                    }

                    if (field_value != '') {

                        if (field_validation_options.indexOf('email') >= 0) {
                            var matches = field_value.match(regexes.email)
                            if (!matches) {
                                $field.manipulateClasses(['error'], ['valid'])
                                valid = false
                            }
                            else {
                                $field.manipulateClasses(['valid'], ['error'])
                            }
                        }

                        else if (field_validation_options.indexOf('password') >= 0) {
                            var matches = field_value.match(regexes.password)
                            if (!matches) {
                                $field.manipulateClasses(['error'], ['valid'])
                                valid = false
                            }
                            else {
                                $field.manipulateClasses(['valid'], ['error'])
                            }
                        }

                        else if (field_validation_options.indexOf('password_confirmation') >= 0) {
                            //matches = field_value.match(regexes.email)
                            //if(!matches){
                            //    return false
                            //}
                            var $password_fields = $validated_fields.filter('[data-validate*=password]')
                            var password_fields_length = $password_fields.length
                            var original_password_field_value
                            for (var j = 0; j < password_fields_length; j++) {
                                var $password_field = $password_fields.eq(j)
                                var password_field_options = $password_field.attr('data-validate').split(' ')
                                if (password_field_options.indexOf('password') >= 0) {
                                    var $original_password_field = $password_field
                                    if ($original_password_field.hasClass('input')) {
                                        var $original_password_field_input = $original_password_field.find('input')
                                        original_password_field_value = $original_password_field_input.val()
                                    }
                                }
                            }

                            if (field_value != original_password_field_value) {
                                $field.manipulateClasses(['error'], ['valid'])
                                valid = false
                            }
                            else {
                                $field.manipulateClasses(['valid'], ['error'])
                            }
                        }

                        else if (field_validation_options.indexOf('first_name') >= 0) {
                            var matches = field_value.match(regexes.first_name)
                            if (!matches) {
                                $field.manipulateClasses(['error'], ['valid'])
                                valid = false
                            }
                            else {
                                $field.manipulateClasses(['valid'], ['error'])
                            }
                        }

                        else if (field_validation_options.indexOf('last_name') >= 0) {
                            var matches = field_value.match(regexes.last_name)
                            if (!matches) {
                                $field.manipulateClasses(['error'], ['valid'])
                                valid = false
                            }
                            else {
                                $field.manipulateClasses(['valid'], ['error'])
                            }
                        }

                        else if (field_validation_options.indexOf('phone') >= 0) {
                            //var matches = field_value.match(regexes.email)
                            //if (!matches) {
                            //    return false
                            //}

                            var matches = field_value.match(/\d/g)
                            var text_number = matches.join('')
                            var text_number_length = text_number.length
                            if (text_number_length >= 6 && text_number_length <= 12) {
                                $field.manipulateClasses(['valid'], ['error'])
                            }
                            else {
                                $field.manipulateClasses(['error'], ['valid'])
                                valid = false
                            }
                        }

                    }
                }

                if (!valid) {
                    $form.manipulateClasses(['error'], ['valid'])
                }
                else {
                    $form.manipulateClasses(['valid'], ['error'])
                }

                return valid
            }
            else{
                return null
            }
        }
    }
})(jQuery)


function validateValue(value, type){
    return regexes.hasOwnProperty(type)? value.match(regexes[type]) : true
}




// /^(((\+)?(\d{2}))?([\(\-]?(\d{3})([\)\-])?)?)?((\d([\-\w]){7}){1})?$/