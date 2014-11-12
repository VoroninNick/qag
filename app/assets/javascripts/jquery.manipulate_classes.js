(function($){
    $.fn.listClasses = function(){
        var classes = []
        //classes = this[0].classN.match(/[a-zA-Z][a-zA-Z0-9\_]{0,}/g)
        classes = this[0] ? this[0].classList : []
        //if(this.attr('class'))
        return classes
    }

    $.fn.manipulateClasses = function(add_classes, remove_classes){
        add_classes = add_classes || []
        var add_classes_length = add_classes.length
        remove_classes = remove_classes || []
        var remove_classes_length = remove_classes.length
        var self = this
        var elements_count = self.length

        for(var i = 0; i < elements_count; i++ ){
            var elem = self[i]
            var class_name = elem.className
            var classes = class_name.match(/[a-zA-Z][a-zA-Z0-9\_]{0,}/g) || []
            for(var j = 0; j < add_classes_length; j++){
                var new_class = add_classes[j]
                if(classes.indexOf(new_class) < 0){
                    classes.push(new_class)
                }
            }

            for(var j = 0; j < remove_classes_length; j++){
                var new_class = remove_classes[j]
                var class_index = classes.indexOf(new_class)
                if(class_index >= 0){
                    classes.splice(class_index, 1)
                }
            }

            var str_classes = classes.join(' ')
            elem.className = str_classes

        }

        return this
    }
})(jQuery)