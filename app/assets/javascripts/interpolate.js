String.prototype.interpolate = function (o) {
	if(o != undefined){
	    return this.replace(/*/{([^{}]*)}/g,*/ /{{([^{{}}]*)}}/g,
	        function (a, b) {
	            var r = o[b];
	            return typeof r === 'string' || typeof r === 'number' ? r : a;
	        }
	    );
	}
	
	return this.toString();	
};