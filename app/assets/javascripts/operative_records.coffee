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
      maxDate: moment().subtract(1, 'days')
      defaultDate: moment(window.location.pathname.split('/')[3], "DDMMYYYY")
     # minDate: moment().subtract(1, 'months')
     # useCurrent: false

    $('#target_day_selector tbody').on('click', 'td.day', ( ->
      url = '/operative_records/all/' + $(this).attr('data-day').split('.').join('')
      if window.location.pathname != url
        $.pjax({ url, container: '#operative_data_for_day'})
    ))

$(document).on('pjax:complete', ready)
$(document).ready(ready)
