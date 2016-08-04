#= require jquery
#= require jquery_ujs

#= require jquery.pjax

#= require moment
#= require bootstrap-datetimepicker
#= require moment/ru.js

#= require bootstrap-sprockets
#= require_tree .

ready = ->

#  $(document).pjax('a:not(.thumbnail):not(.pdf-link)', '[pjax-container]')
#  $(document).pjax('[data-pjax] a, a[data-pjax]', '#pjax-container')
  $(document).pjax('a:not(.thumbnail):not(.pdf-link)', '[pjax-container]')
  $.pjax.defaults.timeout = 4000

$(document).ready(ready)
