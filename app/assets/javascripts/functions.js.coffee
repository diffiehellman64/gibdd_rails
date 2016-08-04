#@showAppMessage = (message, state = 'info') ->
#  html_ = $('#application-messager').html()
#  html_ += "<div class='message-item alert alert-dismissible alert-#{state}' role='alert' data-dismiss='alert' >" +
#             "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" +
#             message +
#           "</div>"
#$('#application-messager').html(html_)
