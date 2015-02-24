var CURRENT_LOCALE = 'en'

function t(key){
    var locale = CURRENT_LOCALE
    if(typeof key == 'string'){
        var key_path_arr = key.split('.')
        key_path_arr.unshift(locale)
        //node_depth = 0
        node = window.locales[locale]
        for(var i=1;node && i<key_path_arr.length ;i++){
            console.log(node.toString())
            var local_node = node[key_path_arr[i]]
            node = local_node
        }

        if(node){
            return node
        }
        else{
            return undefined
        }
    }
    else{
        return undefined
    }
}