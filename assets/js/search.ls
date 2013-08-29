factories = {}
factories.ModelFactory = [
  '$localStorage'

  (ls) ->
    main:
      paragraphs: []
      settings:   ls
]

factories.AjaxFactory = [
  '$http'
  'ModelFactory'

  (http, mf) ->
    find: (collocation) ->
      query = collocation: collocation
      query{store, ssearch} = mf.main.settings

      http.post('/paragraph_collection', query)
        .success (data) ->
          mf.main.paragraphs = data
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
      af.find collocation if /\w+\s\w./ is collocation
]

controllers.ResultsCtrl = [
  '$scope'
  'ModelFactory'

  (s, mf) ->
    s.model = mf.main
]

angular.module(\controllers, []).controller controllers
angular.module \SearchApp, <[ controllers factories ngStorage ]>
