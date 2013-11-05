define ['jquery', 'partake-internal'], ($, api) ->
  partake = api.partake
  partakeUI = api.partakeUI

  initialize = ($div) ->
    queryType = $div.data('query-type')
    ident = $div.data('ident')
    userId = $div.data('user-id')

    createTable = (nthPage, eventStatuses) ->
      if !eventStatuses || !eventStatuses.length
        $('#' + ident + '-none').show();
        return

      $('#' + ident + '-none').hide();
      $tbody = $('#' + ident + '-tbody');
      $tbody.empty();

      for eventStatus in eventStatuses
        event = eventStatus.event
        $tr = $('<tr>')

        if (event.isPrivate)
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
          .text(event.beginDate)
          .appendTo($tr)

        numParticipants = eventStatus.numEnrolledUsers
        if eventStatus.isBeforeDeadline
          numParticipants += eventStatus.numReservedUsers
        amountStr = if eventStatus.isAmountInfinite then '無制限' else eventStatus.amount
        str = numParticipants + "/" + amountStr
        $td = $('<td>')
          .text(str)
          .appendTo($tr)

        $tr.appendTo($tbody)

    update = (nthPage) ->
      SIZE_PER_PAGE = 30
      partake.user.getEvents(userId, queryType, (nthPage - 1) * SIZE_PER_PAGE, SIZE_PER_PAGE)
        .done (json) ->
          createTable(nthPage, json.eventStatuses)
          lst = partakeUI.pagination($('#' + ident + '-pagination'), nthPage, json.totalEventCount, 10)
          for element in lst
            element.anchor.click do (element) ->
              update(element.pageNum)
        .fail partake.defaultFailHandler

    update(1)

  initialize: initialize