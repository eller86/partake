# internal module to manage common dependency and put instance of partake-api

define ['jquery', 'partake', 'bootstrap', 'jquery-ui'], ($, api) ->
  sessionToken = $('meta[name=partake-session-token]').attr('content')

  sessionToken: sessionToken
  partake: api.createPartakeClient sessionToken
