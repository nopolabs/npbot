class ListenerBuilder
  constructor: (@users, @channels, @log) ->

  build: (spec) ->
    users = true
    channels = true
    regex = false
    if typeof spec == 'function'
      type = 'message'
      accept = spec
    else
      type = spec.type || 'message'

      if spec.user || spec.users
        names = spec.users || []
        names.push spec.user if spec.user
        users = (user.id for user in @users when names.indexOf(user.name) != -1)

      if spec.channel || spec.channels
        names = spec.channels || []
        names.push spec.channel if spec.channel
        channels = (channel.id for channel in @channels when names.indexOf(channel.name) != -1)

      regex = spec.regex if spec.regex

      accept = spec.accept || (msg, matches) =>
        @log.info 'ACCEPT', msg, matches

    acceptType = (msg) =>
      if msg.type is type
        return true
      @log.debug 'acceptType', 'REJECTED', type, msg
      false

    acceptUser = (msg) =>
      if users is true or users.indexOf(msg.user) != -1
        return true
      @log.debug 'acceptUser', 'REJECTED', users, msg
      false

    acceptChannel = (msg) =>
      if channels is true or channels.indexOf(msg.channel) != -1
        return true
      @log.debug 'acceptChannel', 'REJECTED', channels, msg
      false

    acceptRegex = (msg) =>
      if not regex
        return true
      if msg.text
        return matches if (matches = regex.exec msg.text)

      @log.debug 'acceptRegex', 'REJECTED', regex, msg
      false

    (msg) =>
      try
        @log.debug 'LISTEN', msg
        if acceptType(msg) and acceptUser(msg) and acceptChannel(msg)
          accept msg, matches if (matches = acceptRegex(msg))
      catch err
        @log.warn err

module.exports = ListenerBuilder