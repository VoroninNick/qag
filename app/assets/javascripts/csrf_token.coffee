initialize_csrf_token = (token)->
  $.ajaxSetup(
    beforeSend: (xhr, settings)->
      if settings.type == 'POST' || settings.type == 'PUT' || settings.type == 'DELETE'
        if (!(/^http:.*/.test(settings.url) || /^https:.*/.test(settings.url)))
          # Only send the token to relative URLs i.e. locally.
          xhr.setRequestHeader("X-CSRFToken", token);

  )

load_csrf_token = ()->
  token = Cookies.get('csrf_token')
  if !token
    $.ajax({
      url: "/csrf_token",
      success: (data, textStatus, jqXHR)->
        Cookies.set('csrf_token', data);
        initialize_csrf_token(data)
    })

  else
    initialize_csrf_token(token)


load_csrf_token()