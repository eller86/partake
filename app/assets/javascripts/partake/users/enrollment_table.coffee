define ['jquery', 'partake-internal'], ($, api) ->
  partake = api.partake
  partakeUI = api.partakeUI

  initialize = ($div) ->
    ident = $div.data('ident')
    userId = $div.data('user-id')

    createTable = (nthPage, ticketStatuses) ->
      if !ticketStatuses || !ticketStatuses.length
        $('#' + ident + '-none').show()
        return

      $('#' + ident + '-none').hide()
      $tbody = $('#' + ident + '-tbody')
      $tbody.empty()

      for ticketStatus in ticketStatuses
        ticket = ticketStatus.ticket
        event = ticketStatus.event
        $tr = $('<tr>')

        if event.isPrivate
          $('<td><img src="@routes.Assets.at("/images/private.png")" title="非公開イベント" /></td>').appendTo($tr)
        else
          $('<td>&nbsp;</td>').appendTo($tr)

        $td = $('<td>')
        $a = $('<a>')
          .attr('href', "/events/" + event.id)
          .text(event.title)
          .appendTo($td)
        $td.appendTo($tr)

        $td = $('<td>')
          .text(event.beginDateText)
          .appendTo($tr)

        $td = $('<td>')
          .text(ticket.name)
          .appendTo($tr)

        $td = $('<td>')
        $td.text(switch (ticketStatus.status)
          when 'enrolled' then '参加'
          when 'enrolledOnWaitingList' then '参加 (補欠)'
          when 'reserved' then '仮参加'
          when 'reservedOnWaitingList' then '仮参加 (補欠)'
          when 'cancelled' then 'キャンセル済'
          else '不明'
        )
        $td.appendTo($tr)

        $tr.appendTo($tbody)

    update = (nthPage) ->
      partake.user.getTickets(userId, (nthPage - 1) * 10, 10)
        .done (json) ->
          createTable(nthPage, json.ticketStatuses)
          lst = partakeUI.pagination($('#' + ident + '-pagination'), nthPage, json.totalTicketCount, 10)
          for element in lst
            element.anchor.click do (element) ->
              update(element.pageNum)
        .fail partake.defaultFailHandler

    update(1)

  initialize: initialize