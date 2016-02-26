window.Cropper ?= {}

# convert bytes into friendly format

Cropper.bytesToSize = (bytes) ->
  sizes = [
    'Bytes'
    'KB'
    'MB'
  ]
  if bytes == 0
    return 'n/a'
  i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
  (bytes / 1024 ** i).toFixed(1) + ' ' + sizes[i]

# check for selected crop region

Cropper.checkForm = ->
  if parseInt($('#w').val())
    alert("uploading...")
    return false

  $('.error').html('Please select a crop region and then press Upload').show()

  return false

# update info by cropping (onChange and onSelect events handler)

Cropper.updateInfo = (e) ->
  $('#x1').val e.x
  $('#y1').val e.y
  $('#x2').val e.x2
  $('#y2').val e.y2
  $('#w').val e.w
  $('#h').val e.h
  return

# clear info by cropping (onRelease event handler)

Cropper.clearInfo = ->
  $('.info #w').val ''
  $('.info #h').val ''
  return

Cropper.fileSelectHandler = ->
  max_file_size = 10 * 1024 * 1024
# get selected file
  oFile = $(this)[0].files[0]
  # hide all errors
  $('.error').hide()
  # check for image type (jpg and png are allowed)
  rFilter = /^(image\/jpeg|image\/png)$/i
  if !rFilter.test(oFile.type)
    $('.error').html('Please select a valid image file (jpg and png are allowed)').show()
    return
  # check for file size
  if oFile.size > max_file_size
    $('.error').html('You have selected too big file, please select a one smaller image file').show()
    return

  # preview element
  oImage = $("#preview")[0]
  # prepare HTML5 FileReader
  oReader = new FileReader



  oReader.onload = (e) ->
    #alert("oReader.onload")
    # e.target.result contains the DataURL which we can use as a source of the image
    oImage.src = e.target.result

    oImage.onload = ->
      #alert("oImage.onload")
# onload event handler
# display step 2
      $('.step-2').fadeIn 500
      # display some basic image info
      sResultFileSize = Cropper.bytesToSize(oFile.size)
      $('#filesize').val sResultFileSize
      $('#filetype').val oFile.type
      $('#filedim').val oImage.naturalWidth + ' x ' + oImage.naturalHeight
      # destroy Jcrop if it is existed
      if typeof jcrop_api != 'undefined'
        jcrop_api.destroy()
        jcrop_api = null
        $('#preview').width oImage.naturalWidth
        $('#preview').height oImage.naturalHeight
      setTimeout (
        ->
          # initialize Jcrop
          $('#preview').Jcrop {
            minSize: [
              32
              32
            ]
            aspectRatio: 1
            bgFade: true
            bgOpacity: .3
            onChange: Cropper.updateInfo
            onSelect: Cropper.updateInfo
            onRelease: Cropper.clearInfo
          },
          ->
            # use the Jcrop API to get the real image size
            bounds = @getBounds()
            boundx = bounds[0]
            boundy = bounds[1]
            # Store the Jcrop API in the jcrop_api variable
            jcrop_api = this

        3000)
      return

    return

  console.log "file", oFile
  # read selected file as DataURL
  oReader.readAsDataURL oFile

  return

# Create variables (in this scope) to hold the Jcrop API and image size
jcrop_api = undefined
boundx = undefined
boundy = undefined
