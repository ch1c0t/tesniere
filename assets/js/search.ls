factories = {}
factories.ModelFactory = [
  '$localStorage'

  (ls) ->
    main:
      sentences:  []
      settings:   ls
]

factories.AjaxFactory = [
  '$http'
  'ModelFactory'

  (http, mf) ->
    find: (collocation) ->
      query = collocation: collocation
      query{store, ssearch} = mf.main.settings

      http.post('/sentence_collection', query)
        .success (data) ->
          mf.main.sentences = data
        .error ->
          alert "Something went wrong."
]
angular.module(\factories, []).factory factories


controllers = {}
controllers.QueryCtrl = [
  '$scope'
  'AjaxFactory'

  (s, af) ->
    s.find = (collocation) ->
      af.find collocation
]

controllers.ResultsCtrl = [
  '$scope'
  'ModelFactory'

  (s, mf) ->
    s.model = mf.main
]

angular.module(\controllers, []).controller controllers
angular.module \SearchApp, <[ controllers factories ngStorage ]>
