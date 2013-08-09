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
          mf.main.sentences = data
        .error ->
          alert "Something went wrong."

    save: (sentences) ->
      http.post('/sentence_collection/new', sentences)
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

controllers.SentenceListCtrl = [
  '$scope'
  'AjaxFactory'
  'ModelFactory'

  (s, af, mf) ->
    s.model = mf.main

    s.save = (sentence, index) ->
      af.save [sentence]
      s.model.sentences.splice index, 1

    s.save-all = (sentences) ->
      af.save sentences
      s.model.sentences = []
]

angular.module(\controllers, []).controller controllers
angular.module \ScalpelApp, <[ controllers factories monospaced.elastic ]>
