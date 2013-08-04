mod = {}
mod.FormCtrl = [
  '$scope'
  '$http'

  (s, http) ->
    s.send = ->
      http.post('/sentences', s.sentence)
        .success ->
          s.sentence.string = ""
        .error ->
          alert "Something went wrong."
]

angular.module(\App.controllers, []).controller mod
angular.module \App, <[ App.controllers ]>
