# internal module to manage common dependency and put instance of partake-api

define ['jquery', 'partake', 'partake-ui', 'bootstrap', 'jquery-ui'], ($, partake, partakeUI) ->
  sessionToken = $('meta[name=partake-session-token]').attr('content')

  sessionToken: sessionToken
  partake: partake.createPartakeClient sessionToken
  partakeUI: partakeUI.createPartakeUIClient sessionToken
