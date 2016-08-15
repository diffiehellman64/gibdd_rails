@showAppMessage = (message, state = 'info') ->
  if message.indexOf('^') != -1
    m = message.split('^')
    message = m[1]
    state = m[0]
  html_ = $('#application-messager').html()
  html_ += "<div class='message-item alert alert-dismissible alert-#{state}' role='alert' data-dismiss='alert' >" +
             "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" +
             message +
           "</div>"
  $('#application-messager').html(html_)
