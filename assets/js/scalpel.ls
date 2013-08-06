factories = {}
factories.ModelFactory = [
  ->
    main:
      sentences: []
]

factories.AjaxFactory = [
  '$http'
  'ModelFactory'

  (http, mf) ->
    segment-paragraph: (string) ->
      http.post('/segment', paragraph: string)
        .success (data) ->
          create-sentence-from = (string) ->
            string: string

          { map } = require 'prelude-ls'
          mf.main.sentences = map create-sentence-from, data
        .error ->
          alert "Something went wrong."
]
angular.module(\factories, []).factory factories


controllers = {}
controllers.ParagraphCtrl = [
  '$scope'
  'AjaxFactory'

  (s, af) ->
    s.paragraph = {}
    s.segment = ->
      af.segment-paragraph s.paragraph.string
]

controllers.ListCtrl = [
  '$scope'
  'ModelFactory'

  (s, mf) ->
    s.model = mf.main
]

angular.module(\controllers, []).controller controllers
angular.module \ScalpelApp, <[ controllers factories monospaced.elastic ]>
