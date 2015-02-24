// String.prototype.supplant = function (o) {
//     return this.replace(/{{([^{{}}]*)}}/g,
//         function (a, b) {
//             return  o != undefined  && typeof r === 'string' || typeof r === 'number' ? o[b] : a;
//         }
//     );
// };


// ===========================================
// -------------------------------------------
// count properties in object
// -------------------------------------------
// ===========================================

if (!Object.keys) {
    Object.keys = function (obj) {
        var keys = [],
            k;
        for (k in obj) {
            if (Object.prototype.hasOwnProperty.call(obj, k)) {
                keys.push(k);
            }
        }
        return keys;
    };
}



// ===========================================
// -------------------------------------------
// interpolates string
// Predefined symbols
// 1. {{variable}}

// -------------------------------------------
// ===========================================



function clone(obj) {
    if (null == obj || "object" != typeof obj) return obj;
    var copy = obj.constructor();
    for (var attr in obj) {
        if (obj.hasOwnProperty(attr)) copy[attr] = obj[attr];
    }
    return copy;
}

Object.self_merge = function(destination, source){
    for (var property in source) {
        if (source.hasOwnProperty(property)) {
            destination[property] = source[property];
        }
    }
    return destination;
}

Object.merge = function(destination, source) {
    dest = clone(destination)
    Object.self_merge(dest, source)
    return dest;
};

// Object.prototype.merge = function(obj){
// 	res = Object.extend(this, obj)
// 	return res
//};







/////////////////////////




function find_view(key, target){
	var parts = key.split('/')
	//var part = parts[0]
	var target = target || window.templates
	parts_last_index = parts.length - 1
	for(var i =0; i < parts.length; i++){
		var required_part = parts[i]
		console.log('required: '+required_part)
		if(target.hasOwnProperty(required_part) && ( (i == parts_last_index) ? typeof target[required_part] != 'object' : true ) ){
			target = target[required_part]

		}
		else{
			return false
		}
	}

	return true
}

function view_source(key, target){
	var parts = key.split('/')
	//var part = parts[0]
	var target = target || window.templates
	parts_last_index = parts.length - 1
	for(var i =0; i < parts.length; i++){
		var required_part = parts[i]
		console.log('required: '+required_part)
		if(target.hasOwnProperty(required_part) && ( (i == parts_last_index) ? typeof target[required_part] != 'object' : true ) ){
			target = target[required_part]

		}
		else{
			return null
		}
	}

	return target
}

function find_template(key){
	var target = window.templates
	return find_view(key, target)
}

function template_source(key){
	var target = window.templates
	return view_source(key, target)
}

function find_layout(key){
	var target = window.layouts
	return find_view(key, target)
}

function layout_source(key){
	var target = window.layouts
	return view_source(key, target)
}

function find_partial(key){
	var target = window.partials
	return find_view(key, target)
}

function partial_source(key){
	var target = window.partials
	return view_source(key, target)
}






function render(options){
	options = options || {}
	defaults = {
		layout: 'modal_layout',
		locals: {},
		template: false
	}

	options = Object.merge(defaults, options)
	var source = ""
	var template_src = null

	if(options.template){
		template_src = template_source(options.template)
	}	

	if(options.layout){
		source = layout_source(options.layout)
	
		if(!options.locals.hasOwnProperty('yield')){
			options.locals.yield = template_src
		}
		if(source){
			console.log(typeof source)
			source = source.interpolate(options.locals)
		}
	}
	else{
		source = template_src
	}

	return source
}

function a(){

}