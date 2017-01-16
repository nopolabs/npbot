SlackBot = require 'slackbots'
Bunyan = require 'bunyan'
ScriptLoader = require './scriptloader'
ListenerBuilder = require './listenerbuilder'

class NpBot extends SlackBot
  constructor: (config) ->
    {@apiToken, @botName, @logLevel = 'info'} = config
    super { token: @apiToken, name: @botName }
    @log = Bunyan.createLogger({name: @botName, level: @logLevel});
    loader = new ScriptLoader(@)
    loader.load './scripts'

  listenerSpecs = []
  listeners = []

  listen: (spec) ->
    listenerSpecs.push spec

  onStart: ->
    builder = new ListenerBuilder(@)
    listeners = (builder.build(spec) for spec in listenerSpecs)

  onMessage: (msg) ->
    @log.debug 'onMessage', msg
    listener(msg) for listener in listeners

  run: ->
    @on 'start', @onStart
    @on 'message', @onMessage

module.exports = NpBot