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