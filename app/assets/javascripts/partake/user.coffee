# FIXME: $ is global variable because index still loads partake-all.js

define [], () ->
  user = 
    isLoggedIn: () ->
      !!user.getUserId()
    getUserId: () ->
      $("meta[name=partake-user-id]").attr('content')

  user
