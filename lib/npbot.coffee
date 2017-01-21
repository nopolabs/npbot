ScriptLoader = require './scriptloader'
ListenerBuilder = require './listenerbuilder'
extend = require 'extend'

class NpBot
  constructor: (@slack, @storage, @log, @config) ->
    @loader = new ScriptLoader(@)

  listenerSpecs = []
  listeners = []
  messageId = 0

  load: (paths...) =>
    @loader.load paths...

  loadFile: (path, file) =>
    @loader.loadFile path, file

  listen: (spec) =>
    listenerSpecs.push spec

  send: (msg) =>
    msg = extend msg, { id: ++messageId }
    try
      @slack.ws.send JSON.stringify(msg)
    catch err
      @log.warn 'SEND', err

  onStart: =>
    @log.debug 'onStart'
    @slack.getUsers().then (data) =>
      users = data.members
      @slack.getChannels().then (data) =>
        channels = data.channels
        builder = new ListenerBuilder(@slack.name, users, channels, @log)
        listeners.push(builder.build(spec)) for spec in listenerSpecs

  onMessage: (msg) =>
    @log.debug 'onMessage', msg, listeners
    listener(msg) for listener in listeners

  run: =>
    @slack.on 'start', @onStart
    @slack.on 'message', @onMessage

module.exports = NpBot