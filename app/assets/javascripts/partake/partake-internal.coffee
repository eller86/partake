# internal module to manage common dependency and put instance of partake-api

define ['jquery', 'partake', 'bootstrap', 'jquery-ui'], ($, api) ->
  partake: api.createPartakeClient $('meta[name=partake-session-token]').attr('content')
