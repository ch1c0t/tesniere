mod = {}
mod.Ctrl = [
  '$scope'
  '$localStorage'

  (s, ls) ->
    s.settings = ls
]

angular.module(\controllers, []).controller mod
angular.module \SettingsApp, <[ controllers ngStorage ]>
