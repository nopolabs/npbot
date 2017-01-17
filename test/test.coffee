require 'coffee-script/register'
extend = require 'extend'

# Assertions and Stubbing
sinon = require 'sinon'
assert = sinon.assert

# TestBot
Bunyan = require 'bunyan'
Slack = require 'slackbots'
NpBot = require '../lib/npbot'

config =
  apiToken: 'no-token-for-testing'
  botName: 'npbot'
  logLevel: 'warn'

users = [{id:'U0001AAAA', name:'test_user'}]
channels = [{id:'C0002BBBB', name:'test_channel'}]
message =
  type: 'message'
  channel: 'C0002BBBB'
  user: 'U0001AAAA'
  text: 'fish'
  ts: '1484597317.000293'
  team: 'T0003CCCC'

slack = sinon.createStubInstance(Slack)

slack.getUsers.returns(then: (f) -> f(users));
slack.getChannels.returns(then: (f) -> f(channels));

log = Bunyan.createLogger(name: config.botName, level: config.logLevel)

bot = new NpBot(slack, log, config)

bot.listen user: 'test_user', channel: 'test_channel', regex: /(fish)/, accept: (msg, matches) =>
  slack.postMessage msg.channel, 'I caught a fish'

bot.run()

bot.onStart()

describe 'NpBot', ->

  describe 'test listener', ->

    beforeEach ->
      slack.postMessage.reset()

    it 'responds to matched message', ->
      bot.onMessage(message)
      assert.calledOnce slack.postMessage
      assert.calledWithExactly slack.postMessage, 'C0002BBBB', 'I caught a fish'

    it 'does not respond to wrong user', ->
      message = extend message, {user:'U9999ZZZZ'}
      bot.onMessage(message)
      assert.notCalled slack.postMessage

    it 'does not respond to wrong channel', ->
      message = extend message, {channel:'C9999ZZZZ'}
      bot.onMessage(message)
      assert.notCalled slack.postMessage

    it 'does not respond to non-matching text', ->
      message = extend message, {text:'panda bear'}
      bot.onMessage(message)
      assert.notCalled slack.postMessage

    it 'does not respond to non-message type', ->
      message = extend message, {type:'hello'}
      bot.onMessage(message)
      assert.notCalled slack.postMessage
