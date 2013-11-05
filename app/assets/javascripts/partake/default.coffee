requirejs.config
  paths:
    'jquery': '../partake/jquery-fixup'
    'jquery-base': '../jquery/jquery'
    'jquery-ui': '../partake/jquery-ui-fixup'
    'jquery-ui-base': '../jquery/jquery-ui'
    'partake-internal': 'partake-internal'
    'bootstrap': '../bootstrap/bootstrap'
    'jquery-json': '../jquery/plugins/jquery-json'
    'jquery-masonry': '../jquery/plugins/jquery-masonry'
    'jquery-ui-datepicker': '../jquery/plugins/jquery-ui-datepicker-ja'
    'jquery-ui-timepicker': '../jquery/plugins/jquery-ui-timepicker-ja'
    'jquery-ui-timepicker-addon': '../jquery/plugins/jquery-ui-timepicker-addon'
  shim:
    'bootstrap': ['jquery']
    'jquery': ['jquery-base']
    'jquery-base': { exports: 'jQuery' }
    'jquery-ui': ['jquery-ui-base']
    'jquery-ui-base': ['jquery']
    'jquery-ui-timepicker-addon': ['jquery-ui']
    'jquery-ui-datepicker': ['jquery-ui']
    'jquery-ui-timepicker': ['jquery-ui', 'jquery-ui-timepicker-addon']
    'jquery-json': ['jquery']
    'jquery-masonry': ['jquery']

require ['base/header'], () ->
  return
