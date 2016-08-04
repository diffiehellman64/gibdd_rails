ready = ->

  if window.location.pathname == '/operative_records/new'
    disDatesArr = $('#operative_record_target_day').attr('dis_dates').split('|')
    disDatesArrMoment = []
    for i in [0...disDatesArr.length]
      disDatesArrMoment[i] = moment(disDatesArr[i], "DDMMYYYY")
  
    defDate = $('#operative_record_target_day').attr('def_date')

    $('#operative_record_target_day').datetimepicker 
      format: 'DD.MM.YYYY'
      locale: 'ru'
      disabledDates: disDatesArrMoment
      maxDate: moment().subtract(1, 'days')
      minDate: moment().subtract(1, 'months')
      # useCurrent: false
      # defaultDate: moment('31072016', "DDMMYYYY")

  re = /\/operative_records\/all\/*/i
  if window.location.pathname.match(re) != null
    $('#target_day_selector').datetimepicker 
      format: 'DD.MM.YYYY'
      locale: 'ru'
      keepOpen: true
      inline: true
     # sideBySide: true
      maxDate: moment().subtract(1, 'days')
     # minDate: moment().subtract(1, 'months')
     # useCurrent: false

    console.log $('#target_day_selector').val()
    #$('#target_day_selector').click ->
    $('body').on('change', '#target_day_selector', ( ->
      console.log $('#target_day_selector').val()
      $.ajax '/operative_records/all/' + $('#target_day_selector').val().split('.').join(''),
        type: 'GET'
        error: (jqXHR) ->
          console.log jqXHR.status
          #showAppMessage('<strong>Error:</strong> ' + jqXHR.status, 'danger');
        success: (jqXHR) ->
          console.log jqXHR.status
          #showAppMessage('<strong>Error:</strong> ' + jqXHR.status, 'success');
          #$(version_tr).fadeOut(200)
          #showAppMessage('<strong>Success!</strong> Version deleted!', 'success');
    ))

#  re = /\/operative_records\/\d\/edit/i
#  if window.location.pathname == '/operative_records/new' || window.location.pathname.match(re) != null
#    onkeyup_var = true
#    validate_url = '/operative_records/validate'
#    validator = $('#new_operative_record, [id^=edit_operative_record_]').validate(
#      # => Bootstrap integration <= #
#      errorClass: 'help-block'
#      errorElement: 'span'
#      # debug: true
#      highlight: (element) ->
#        $(element).closest('.form-group').addClass('has-error')
#        $(element).closest('.form-group').removeClass('has-success');
#      unhighlight: (element) ->
#        $(element).closest('.form-group').removeClass('has-error');
#        $(element).closest('.form-group').addClass('has-success');
#      # -- Bootstrap integration -- #
#      debug: true
#      rules:
#        'operative_record[target_day]':
#          required: true
#          remote:
#            url: validate_url
#            type: 'post'
#            onkeyup: onkeyup_var
#        'operative_record[registry_emergency_count]':
#          remote:
#            url: validate_url
#            type: 'post'
#            onkeyup: onkeyup_var
#        'operative_record[dead_count]':
#          remote:
#            url: validate_url
#            type: 'post'
#            onkeyup: onkeyup_var
#        'operative_record[personal_count]':
#          remote:
#            url: validate_url
#            type: 'post'
#            onkeyup: onkeyup_var
#    )

$(document).on('pjax:complete', ready)
$(document).ready(ready)
