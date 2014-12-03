$('#dashboard-content form.simple_form.edit_user').each(function(){
    var $form = $(this)
    $form.addClass(modeViewClass)


    $form.find('.input').each(function(){
        var $input_wrapper = $(this)
        $input_wrapper.append('<div class="js-trigger button save-field-button"></div>')
    })

    $form.on('focusin focusout click', ['input', '.js-trigger'].join(','), function(event){
        event.preventDefault()
        var $this = $(this)
        var $form = $this.closest('form')
        if(event.type == 'focusin'){
            if($this.get(0).tagName.toLowerCase() == 'input' ){
                var $input = $this
                var $input_wrap = $input.closest('div.input')
                $input_wrap.addClass('focus')
            }
        }

        else if(event.type == 'focusout'){
            if($this.get(0).tagName.toLowerCase() == 'input' ){
                var $input = $this
                var $input_wrap = $input.closest('div.input')
                $input_wrap.removeClass('focus')
            }
        }

        else if(event.type == 'click'){
            if($this.hasClass('js-trigger')){
                var $js_trigger = $this
                if($js_trigger.hasClass(modeClass)){
                    if($form.hasClass(modeViewClass)){
                        $form.removeClass(modeViewClass).addClass(modeEditClass)
                    }
                    else{
                        $form.removeClass(modeEditClass).addClass(modeViewClass)
                    }
                }
            }
        }
    })

})