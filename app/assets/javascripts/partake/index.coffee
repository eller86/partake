requirejs.config
  paths:
    'jquery': '../jquery/jquery'
    'jquery-ui': '../jquery/jquery-ui'
    'partake-internal': 'partake-internal'
    'bootstrap': '../bootstrap/bootstrap'
    'jquery-json': '../jquery/plugins/jquery-json'
    'jquery-masonry': '../jquery/plugins/jquery-masonry'
    'jquery-ui-datepicker': '../jquery/plugins/jquery-ui-datepicker-ja'
    'jquery-ui-timepicker': '../jquery/plugins/jquery-ui-timepicker-ja'
    'jquery-ui-timepicker-addon': '../jquery/plugins/jquery-ui-timepicker-addon'
  shim:
    'jquery': { exports: 'jQuery' }
    'jquery-ui': ['jquery']
    'jquery-ui-timepicker-addon': ['jquery-ui']
    'jquery-ui-datepicker': ['jquery-ui']
    'jquery-ui-timepicker': ['jquery-ui', 'jquery-ui-timepicker-addon']

require ['jquery', 'user', 'index', 'partake-internal', 'base/header', 'events/search'], ($, user, index, api) ->
  partake = api.partake
  displayUpcomingEvents = ->
    partake.account.getTickets('upcoming', 0, 10)
        .done (json) ->
          elem = $('#upcoming-participating-events').empty()
          if json.ticketStatuses.length == 0
            elem.append $('<p>').text('参加予定イベントはありません。')
            return

          table = $('<table class="table"></table>')
          table.append($('<tr><th>タイトル</th><th>開催日時</th><th>ステータス</th></tr>'))
          for ticket in json.ticketStatuses
            title = $('<td>').append $('<a>').text(ticket.event.title).attr('href', '/events/' + ticket.event.id)
            date = $('<td>').text(ticket.event.beginDateText)
            status = $('<td>').text(ticket.status)
            table.append $('<tr>').append(title).append(date).append(status)
          elem.append(table)
        .fail partake.defaultFailHandler

  displayManagingEvents = ->
    partake.account.getEvents('upcomingManaging', 0, 10)
        .done (json) ->
          elem = $('#upcoming-managing-events').empty()
          if json.eventStatuses.length == 0
            elem.append $('<p>').text('管理しているイベントはありません。')
            return

          table = $('<table class="table"></table>')
          table.append($('<tr><th>タイトル</th><th>開催日時</th><th>参加人数</th></tr>'))
          for event in json.eventStatuses
            title = $('<td>').append $('<a>').text(event.event.title).attr('href', '/events/' + event.event.id)
            date = $('<td>').text(event.event.beginDateText)
            if event.event.draft
              title.append $('<span class="label">下書</span>')
            else if (event.event.passcode && event.event.passcode != "")
              title.append $('<span class="label">非公開</span>')
            date = $('<td>').text(event.event.beginDateText)
            status = $('<td>').text(event.numEnrolledUsers + event.numReservedUsers)
            table.append $('<tr>').append(title).append(date).append(status)
          elem.append(table)
        .fail partake.defaultFailHandler

  $('#top-create-event').click (e) ->
    if user.isLoggedIn()
      $('#create-event-dialog').modal('show')
    else
      location.href = '/loginRequired'

  if user.isLoggedIn()
    displayUpcomingEvents()
    displayManagingEvents()
