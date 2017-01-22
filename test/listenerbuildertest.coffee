require 'coffee-script/register'
extend = require 'extend'

# Assertions and Stubbing
sinon = require 'sinon'
assert = sinon.assert

Bunyan = require 'bunyan'
log = Bunyan.createLogger(name: 'logger', level: 'info')

users = [{id:'U0001AAAA', name:'test_user'}]
channels = [{id:'C0002BBBB', name:'test_channel'}]
message =
  type: 'message'
  channel: 'C0002BBBB'
  user: 'U0001AAAA'
  text: ''
  ts: '1484597317.000293'
  team: 'T0003CCCC'

ListenerBuilder = require '../lib/listenerbuilder'
builder = new ListenerBuilder('test_builder', users, channels, log)
accept = false
listen = false

describe 'ListenerBuilder', ->

  beforeEach ->
    accept = sinon.spy()

  describe 'accept function', ->

    it 'gets called with message', ->
      listen = builder.build(accept)
      listen message
      assert.calledWith accept, message

  describe "{mentions: 'test_user'}", ->

    beforeEach ->
      listen = builder.build(mentions: 'test_user', accept: accept)

    it "does not match 'waldo'", ->
      message.text = 'waldo'
      listen message
      assert.notCalled accept

    it "does not match 'test_user'", ->
      message.text = 'test_user'
      listen message
      assert.notCalled accept

    it "does not match '@test_user'", ->
      message.text = '@test_user'
      listen message
      assert.notCalled accept

    it "matches '<@U0001AAAA>'", ->
      message.text = '<@U0001AAAA>'
      listen message
      assert.calledWith accept, message

    it "matches 'help <@U0001AAAA>'", ->
      message.text = '<@U0001AAAA>'
      listen message
      assert.calledWith accept, message

    it "matches '<@U0001AAAA> help'", ->
      message.text = '<@U0001AAAA>'
      listen message
      assert.calledWith accept, message
