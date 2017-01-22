require 'coffee-script/register'
extend = require 'extend'

# Assertions and Stubbing
sinon = require 'sinon'
assert = sinon.assert

Bunyan = require 'bunyan'
log = Bunyan.createLogger(name: 'logger', level: 'info')

users = [
  {id:'U0001AAAA', name:'test_user'},
  {id:'U1000ZZZZ', name:'other_user'}
]
channels = [
  {id:'C0002BBBB', name:'test_channel'},
  {id:'C2000YYYY', name:'other_channel'}
]

ListenerBuilder = require '../lib/listenerbuilder'
builder = new ListenerBuilder('test_builder', users, channels, log)
accept = false
listen = false

messageWith = (overrides) ->
  message =
    type: 'message'
    channel: 'C0002BBBB'
    user: 'U0001AAAA'
    text: ''
    ts: '1484597317.000293'
    team: 'T0003CCCC'
  extend message, overrides

describe 'ListenerBuilder', ->

  beforeEach ->
    accept = sinon.spy()

  describe 'accept function', ->

    it 'gets called with message', ->
      listen = builder.build(accept)
      msg = messageWith({})
      listen msg
      assert.calledWith accept, msg

  describe "{mentions: 'test_user'}", ->

    beforeEach ->
      listen = builder.build(mentions: 'test_user', accept: accept)

    it "does not match 'waldo'", ->
      listen messageWith(text: 'waldo')
      assert.notCalled accept

    it "does not match 'test_user'", ->
      listen messageWith(text: 'test_user')
      assert.notCalled accept

    it "does not match '@test_user'", ->
      listen messageWith(text: '@test_user')
      assert.notCalled accept

    it "matches '<@U0001AAAA>'", ->
      msg = messageWith(text: '<@U0001AAAA>')
      listen msg
      assert.calledWith accept, msg

    it "matches 'help <@U0001AAAA>'", ->
      msg = messageWith(text: 'help <@U0001AAAA>')
      listen msg
      assert.calledWith accept, msg

    it "matches '<@U0001AAAA> help'", ->
      msg = messageWith(text: '<@U0001AAAA> help')
      listen msg
      assert.calledWith accept, msg

  describe "{type: 'message'}", ->

    beforeEach ->
      listen = builder.build(type: 'message', accept: accept)

    it "does not match 'non-message'", ->
      listen messageWith(type: 'non-message')
      assert.notCalled accept

    it "matches 'message'", ->
      msg = messageWith(type: 'message')
      listen msg
      assert.calledWith accept, msg

  describe "{user: 'test_user'}", ->

    beforeEach ->
      listen = builder.build(user: 'test_user', accept: accept)

    it "does not match 'unknown_user'", ->
      listen messageWith(user: 'unknown_user')
      assert.notCalled accept

    it "does not match 'other_user'", ->
      listen messageWith(user: 'U1000ZZZZ')
      assert.notCalled accept

    it "matches 'test_user'", ->
      msg = messageWith(user: 'U0001AAAA')
      listen msg
      assert.calledWith accept, msg

  describe "{users: ['test_user','other_user']}", ->

    beforeEach ->
      listen = builder.build(users: ['test_user','other_user'], accept: accept)

    it "does not match 'unknown_user'", ->
      listen messageWith(user: 'unknown_user')
      assert.notCalled accept

    it "matches 'other_user'", ->
      msg = messageWith(user: 'U1000ZZZZ')
      listen msg
      assert.calledWith accept, msg

    it "matches 'test_user'", ->
      msg = messageWith(user: 'U0001AAAA')
      listen msg
      assert.calledWith accept, msg

  describe "{channel: 'test_channel'}", ->

    beforeEach ->
      listen = builder.build(channel: 'test_channel', accept: accept)

    it "does not match 'unknown_channel'", ->
      listen messageWith(channel: 'unknown_channel')
      assert.notCalled accept

    it "does not match 'other_channel'", ->
      listen messageWith(channel: 'C2000YYYY')
      assert.notCalled accept

    it "matches 'test_channel'", ->
      msg = messageWith(channel: 'C0002BBBB')
      listen msg
      assert.calledWith accept, msg

  describe "{channels: ['test_channel','other_channel']}", ->

    beforeEach ->
      listen = builder.build(channels: ['test_channel','other_channel'], accept: accept)

    it "does not match 'unknown_channel'", ->
      listen messageWith(channel: 'unknown_channel')
      assert.notCalled accept

    it "matches 'other_channel'", ->
      msg = messageWith(channel: 'C2000YYYY')
      listen msg
      assert.calledWith accept, msg

    it "matches 'test_channel'", ->
      msg = messageWith(channel: 'C0002BBBB')
      listen msg
      assert.calledWith accept, msg

  describe "{regex: /(\d{4})-(\d{2})-(\d{2})/}", ->

    beforeEach ->
      listen = builder.build(regex: /(\d{4})-(\d{2})-(\d{2})/, accept: accept)

    it "does not match 'Jan 01, 2016'", ->
      listen messageWith(text: 'Jan 01, 2016')
      assert.notCalled accept

    it "matches 'It started on 2016-01-01'", ->
      msg = messageWith(text: 'It started on 2016-01-01')
      heard =
        matches: /(\d{4})-(\d{2})-(\d{2})/.exec 'It started on 2016-01-01'
        mentioned: true
      listen msg
      assert.calledWith accept, msg, heard
