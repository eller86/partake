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

require ['jquery', 'partake-internal', 'base/header'], ($, api) ->
  partake = api.partake
  
  # FIXME partake.in has bug, partake object should be global
  window.partake = partake

  modifySetting = (form) ->
    key = form.data("key")
    value = form.find("*[name=key]").val()
    partake.admin.modifySetting(key, value)
      .done () ->
        statusSpan = form.find(".text-info")
        $(statusSpan).hide().text('保存しました').fadeIn(500)
      .fail partake.defaultFailHandler

  $("form.modify-setting").submit (e) ->
    e.preventDefault()
    modifySetting $(this)
    return false

  $recreateIndexForm = $("#recreate-index")
  $submitButton = $recreateIndexForm.find("input[type=submit]")
  $statusSpan = $recreateIndexForm.find(".text-info");
  $recreateIndexForm.submit (e) ->
    url = $recreateIndexForm.attr("action")
    e.preventDefault();
    $submitButton.prop("disabled", true)
    $.post(url,
      sessionToken: api.sessionToken
    ).done( () ->
        $statusSpan.hide().text('再作成しました').fadeIn(500);
    ).fail(
      partake.defaultFailHandler
    ).always( () ->
        $submitButton.prop("disabled", false)
    )
