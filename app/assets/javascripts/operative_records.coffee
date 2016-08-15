ready = ->
   
  $('ul.tabs').each( () ->
    $tabs = $(this).find('li')
    $activeTab = $(this).find('li.active')[0]
    if !$activeTab 
      $activeTab = $tabs[0]
      $($activeTab).addClass('active')
    $content = $activeTab.children[0].hash
    $tabs.each( () ->
      $(this.children[0].hash).hide()
    )
    $($content).show()
    $(this).on('click', 'li', (e) ->
      $($activeTab).removeClass('active')
      $($content).hide()
      $activeTab = $(this)
      $content = $($activeTab[0].children[0].hash)
      $activeTab.addClass('active');
      $($content).show();
      e.preventDefault();
    )
  )

 
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
  
    $('#operative_data_for_day tr td').each( ->
      if $(this).html() == '0'
        $(this).html('.')
#        $(this).addClass('info')
    )
  
    () ->
      tabContainers = $('div.tabs > div');
      tabContainers.hide().filter(':first').show()
      $('div.tabs ul.tabNavigation a').click( ->
        tabContainers.hide()
        tabContainers.filter(this.hash).show()
        $('div.tabs ul.tabNavigation a').removeClass('selected')
        $(this).addClass('selected')
        return false;
      ).filter(':first').click()

    $('#target_day_selector').datetimepicker 
      format: 'DD.MM.YYYY'
      locale: 'ru'
      keepOpen: true
      inline: true
      maxDate: moment()#.subtract(1, 'days')
      defaultDate: moment(window.location.pathname.split('/')[3], "DDMMYYYY")
     # minDate: moment().subtract(1, 'months')
     # useCurrent: false

    $('#target_day_selector tbody').on('click', 'td.day', (e) ->
      url = '/operative_records/all/' + $(this).attr('data-day').split('.').join('')
      if window.location.pathname != url and !$(this).hasClass('disabled')
        $.pjax({url: url, container: '#operative_info'})
    )

$(document).on('pjax:complete', ready)
$(document).ready(ready)
