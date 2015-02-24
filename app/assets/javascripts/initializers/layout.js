dialogs = []

// ====================================================================
	// --------------------------------------------------------------------
	// dialog classes:
	// 1. modal-open
	//
	// <html></html> classes:
	// 1. html-modal-open
	// --------------------------------------------------------------------
	// ====================================================================


function Dialog(render_options){
	//var dialog = Dialog.getDialog(dialog_key)
	//var need_create = false
	//var $dialog = null
	//if(!dialog){
		//need_create = true
		//dialog_key = dialog_key || 'dialog_' + (dialogs.length + 1)

		var source = render(render_options)

		var dialog_source = source

		var $dialog = $(dialog_source)

		
		var dialog = this
		this.jquery_object = $dialog
		//this.key = dialog_key

		//dialog = { key: dialog_key, jquery_object: $dialog }

		

		$dialog.on('click', '.popup-height-overlay, #popup-close-button', function(){
			dialog.hide()
		})

		$modal_windows_wrapper.append($dialog)
	//}
	//else{
		//$dialog = dialog.jquery_object
	//}
}

//function closeDialog(){
	//this.hideDialog($dialog)
//}

Dialog.get = function(dialog_key, render_options){
	var dialog = null

	var param_dialog_key = dialog_key


	var $dialog = null
	var dialog_key = false
	var typeof_param_dialog_key = typeof param_dialog_key
	if(typeof_param_dialog_key == 'object'){
		if(dialog instanceof jQuery){ // instance of jQuery
			$dialog = dialog
		}
		else{
			dialog = param_dialog_key
			$dialog = dialog.jquery_object
		}
	}
	else{ //  if(typeof_param_dialog_key == 'string')
		//dialog_key = dialog
	}

	if(dialog){
		return dialog
	}

	else{ //if(!$dialog)
		//if(dialog_key){
			//var dialog = $this_initializer.getDialog(dialog_key)
			//$dialog = dialog.jquery_object
		//}

		dialog_key = param_dialog_key
		var i=dialogs.length;
		while(i--){// for(var i=0; i<dialogs.length; i++)
			dialog = dialogs[i]

			console.log('dialog_key: ', dialog_key == dialog.key)
			if(dialog.key == dialog_key){
				return dialog
			}
		}
	}

	

	render_options = render_options || {}

	dialog = new Dialog(render_options)

	dialog.key = dialog_key

	dialogs.push(dialog)

	return dialog
}

Dialog.find = function(dialog_key){
	/*for(var i=0; i<dialogs.length; i++){
		var dialog = dialogs[i]
		if(dialog.key == dialog_key){
			return true
		}  
	}*/

	var dialog = null
	var i = dialog.length
	while(i--){
		dialog = dialogs[i]
		if(dialog.key == dialog_key){
			return true
		}	
	}

	return false
}

Dialog.prototype.hide = function(){
	

	var dialog = this
    var $dialog = this.jquery_object

	if($dialog){
		$dialog.removeClass('modal-open')
		$html.removeClass('html-modal-open')	
	}	
}

Dialog.prototype.show = function(render_options, dialog_key){
	//render_options = Object.merge(render_options, defaults)

	$html.addClass('html-modal-open')

	$dialog = this.jquery_object

	//if(!need_create){
	$dialog.addClass('modal-open')
	//}
	

}

function getSignInDialog(argument) {
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/new', locals: { modal_id: 'users_sessions-new-get' }} )
}

function getSignedInSuccessfullyDialog(){
	return Dialog.get('devise_sessions_signed_in_successfully', {template: 'devise/sessions/successfully_signed_in', locals: { modal_id: 'signed_in_successfully' } } )
}

function getSignUpDialog(){
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/create', locals: { modal_id: 'users_sessions-new-get' }} )

	
}

function getSignedUpSuccessfullyDialog(){
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/create', locals: { modal_id: 'users_sessions-new-get' }} )
}

function getConfirmedSuccessfullyDialog(){
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/create', locals: { modal_id: 'users_sessions-new-get' }} )
}

function getSignedUpDialog(){
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/create', locals: { modal_id: 'users_sessions-new-get' }} )
}

function getLoggedOutSuccessfullyDialog(){
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/create', locals: { modal_id: 'users_sessions-new-get' }} )
}

function getPasswordSentDialog(){
	return Dialog.get('devise_sessions_new', {template: 'devise/sessions/create', locals: { modal_id: 'users_sessions-new-get' }} )
}






(function($){
initializers.layout = {

	global_variables: function(){
		$header = $('#header')
		logged_in = $html.hasClass('logged-in')
		$modal_windows_wrapper = $('#modal-windows-wrapper')
		$header_menu_user_wrapper = $('#header-menu-user-wrapper')


		
	},
	local_variables: function(){

	},
	condition: function(){
		return true
	},
	//initialize_priority: 100
	initialize: function(){
		$this_initializer = this
		//this.initializeUserIcon()

		this.global_variables()

        //var sign_in_dialog = getSignInDialog()
        //var $sign_in_dialog = sign_in_dialog.jquery_object
        //var $sign_in_form = $sign_in_dialog.find('form')
        //$sign_in_form.tinyValidation({validateOnKeyUp: true})



		$modal_windows_wrapper.on('submit','form', function(event){
			event.preventDefault()
			var $form = $(this)
			var form_id = $form.attr('id')
			//console.log(form_id)
			switch(form_id){
				case 'new_user':

					var sign_in_dialog = getSignInDialog()
                    var $sign_in_dialog = sign_in_dialog.jquery_object
                    var $sign_in_form = $sign_in_dialog.find('form')
					var signed_in_successfully = getSignedInSuccessfullyDialog()
					console.log('change_dialog', sign_in_dialog.key, signed_in_successfully.key)
                    if($sign_in_form.){

                    }
					sign_in_dialog.hide()

					signed_in_successfully.show()
					break
				
			}
		})


		$header_menu_user_wrapper.on('click', 'a.popup-link', function(event){
			if(logged_in){

			}
			else{
				event.preventDefault()
				var sign_in_dialog = getSignInDialog()

                var $sign_in_dialog = sign_in_dialog.jquery_object
                var $sign_in_form = $sign_in_dialog.find('form')
                $sign_in_form.tinyValidation({validateOnKeyUp: true})

				sign_in_dialog.show()
			}
		})


	},
	initializeUserIcon: function(){

		$header_menu_user_icon = $('#header-menu-user')
		$new_user_session_popup_wrapper = $('#new_user_session-popup-wrapper')
		$new_user_session_popup = $new_user_session_popup_wrapper.find('.popup')

		str = $("<div />").append($header_menu_user_icon.clone()).html();
		rebuilded_str = str.replace('<a', '<label').replace('</a', '</label')
		$header_menu_user_icon.replaceWith(rebuilded_str)
	}

	
	

	

	

	
}
}
)(jQuery)