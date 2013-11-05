define ['jquery', 'partake-internal', 'user', 'jquery-ui-timepicker', 'bootstrap'], ($, api, user) ->
  partake = api.partake

  unless user.isLoggedIn()
    $('#nav-create-event').click () ->
      location.href = '/loginRequired'
  else
    $('#nav-create-event').click (e) ->
      $('#create-event-dialog').modal('show')

  $('#btn-login-by-hatena').click () ->
    name = $("#login-hatena-username").val().replace(/^\s+|\s+$/g, "")
    ident = "http://www.hatena.ne.jp/" + name
    $("#login-hatena-openid-identifier").val(ident)
    document.loginByHatenaForm.submit()

  $(document).ready () ->
    $('#create-event-form-begin-date-input').datetimepicker
      dateFormat: 'yy-mm-dd'
    $('#create-event-form-end-date-input').datetimepicker
      dateFormat: 'yy-mm-dd'

    $('.disable-keypress-submit').keypress (e) ->
      e.which != 13 # If enterkey is pressed.

    $('#create-event-dialog-submit').click (e) ->
      title = $('#create-event-form-title').val()
      beginDate = $('#create-event-form-begin-date-input').val()
      usesEndDate = $('#create-event-form-end-date-checkbox').is(':checked')
      endDate = if usesEndDate then $('create-event-form-end-date-input').val() else null

      partake.event.create(title, beginDate, endDate)
        .done (json) ->
          location.href = '/events/edit/basic/' + json.eventId
        .fail partake.defaultFailHandler
