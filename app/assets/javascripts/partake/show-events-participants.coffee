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

  removeAttendant = (userId, ticketId) ->
    unless window.confirm('参加者を削除しようとしています。この操作は取り消せません。削除しますか？')
      return

    partake.ticket.removeAttendant(userId, ticketId)
      .done (json) ->
        location.reload()
      .fail partake.defaultFailHandler

  changeAttendance = (userId, ticketId, status) ->
    id = ticketId + '-' + userId
    partake.ticket.changeAttendance(userId, ticketId, status)
      .done (json) ->
        $("#attendance-status-" + id).html("保存しました")
      .fail (xhr) ->
        $("#attendance-status-" + id).html("保存時にエラーが発生しました")

  $(document).on 'click', 'a.remove-participant', (e) ->
    $a = $(this)
    ticket_id = $a.data('ticket-id')
    user_id   = $a.data('user-id')
    removeAttendant(user_id, ticket_id)

  $(document).on 'change', 'input.change-attendance', (e) ->
    $radio = $(this)
    ticket_id = $radio.data('ticket-id')
    user_id   = $radio.data('user-id')
    status    = $radio.val()
    changeAttendance(userId, ticketId, status)
