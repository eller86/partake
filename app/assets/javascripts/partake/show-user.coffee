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

require ['jquery', 'partake-internal', 'users/event_table', 'users/enrollment_table', 'base/header'], ($, api, event_table, enrollment_table) ->
  partake = api.partake
  $banButton = null

  # FIXME partake.in has bug, partake object should be global
  window.partake = partake

  updateBanButton = (user) ->
    if (user.isBanned)
      $banButton.removeClass("btn-warning").data("target-state", false).text("イベント作成を許可する")
    else
      $banButton.addClass("btn-warning").data("target-state", true).text("イベント作成を禁止する")
    $banButton.prop('disabled', false)

  $(document).ready () ->
    $banButton = $("#ban-user")
    return if $banButton.length == 0
    targetUserId = $banButton.data("user-id")

    $banButton.click (e) ->
      targetState = $banButton.data("target-state")

      $banButton.prop('disabled', true)
      partake.account.ban(targetUserId, targetState)
        .done (user) ->
          updateBanButton(user)
        .fail partake.defaultFailHandler

    partake.account.getBan(targetUserId)
      .done (user) ->
        updateBanButton(user)
      .fail partake.defaultFailHandler

    event_table.initialize($("#owner-whole"))
    enrollment_table.initialize($("#owner-whole"))