for(var initializer_key in initializers){
	var initializer = initializers[initializer_key]
	var condition = initializer.condition
	if(typeof condition == 'function'){
		condition = condition()

	}

	if(condition){
		initializer.initialize()
	}
}