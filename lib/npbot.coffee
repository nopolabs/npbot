ScriptLoader = require './scriptloader'
ListenerBuilder = require './listenerbuilder'

class NpBot
  constructor: (@slack, @log, @config) ->
    @loader = new ScriptLoader(@)

  listenerSpecs = []
  listeners = []

  load: (paths...) =>
    @loader.load paths...

  loadFile: (path, file) =>
    @loader.loadFile path, file

  listen: (spec) =>
    listenerSpecs.push spec

  onStart: =>
    @log.debug 'onStart'
    @slack.getUsers().then (users) =>
      @slack.getChannels().then (channels) =>
        builder = new ListenerBuilder(users, channels, @log)
        listeners = (builder.build(spec) for spec in listenerSpecs)

  onMessage: (msg) =>
    @log.debug 'onMessage', msg, listeners
    listener(msg) for listener in listeners

  run: =>
    @slack.on 'start', @onStart
    @slack.on 'message', @onMessage

module.exports = NpBot