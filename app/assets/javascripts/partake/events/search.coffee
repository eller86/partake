define ['jquery', 'partake-internal', 'jquery-masonry', 'jquery-json'], ($, api) ->
  partake = api.partake
  idx = 0
  no_image_src = $('meta[name=partake-no-image]').attr('content')
  $searched_event = $('#searched-events')

  doRenderNoResults = () ->
    $searched_event.hide()
    $('#searched-events-not-found').fadeIn(500)

  $searched_event.masonry
    itemSelector : '.masonry-box'

  cloneTemplate = (newPrefix) ->
    template = $('#template')
    cloned = template.clone(true)
    cloned.find("[id^=template]").each () ->
      id = $(this).attr('id').replace('template', newPrefix)
      $(this).attr('id', id)

    cloned.attr('id', newPrefix).show()

  render = (json) ->
    $searched_event.show()
    $('#searched-events-not-found').hide()

    events = json.events
    $searched_event.empty()

    if (events.length == 0)
        doRenderNoResults()
        return

    for event in events
      prefix = "e" + ++idx
      template = cloneTemplate(prefix)

      $searched_event.append(template)
      $('#' + prefix + '-image-link').attr('href', '/events/' + event.id)
      if (event.foreImageId)
        $('#' + prefix + '-image').attr('src', '/images/thumbnail/' + event.foreImageId)
      else
        $('#' + prefix + '-image').attr('src', no_image_src)

      $('#' + prefix + '-title').attr('href', '/events/' + event.id)
      $('#' + prefix + '-title').text(event.title)
      $('#' + prefix + '-summary').text(event.summary)
      $('#' + prefix + '-date').text(event.beginDateText)

    $searched_event.imagesLoaded () ->
      $searched_event.masonry('reload')

  doSearch = () ->
    query = $('#search-term').val()
    category = $('#category option:selected').val() || 'all'
    sortOrder = $('#sort-order option:selected').val() || 'createdAt'
    beforeDeadlineOnly = $('#before-deadline-only').is(':checked')

    partake.event.search(query, category, sortOrder, beforeDeadlineOnly, 30)
    .done (json) ->
        $('#textareaToSavetemporaryJSON').val($.toJSON(json))
        render(json)
    .fail partake.defaultFailHandler

  $('#search-form').submit () ->
    doSearch()
    false;

  $('#search-button').click(doSearch)

  $(document).ready () ->
    try
      jsonText = $('#textareaToSavetemporaryJSON').val()
      if (jsonText == null || jsonText == "")
        # No value was saved. We do default search.
        doSearch()
        return

      json = $.parseJSON(jsonText)
      render(json)
    catch e
      if (window.console)
        console.log(e)
