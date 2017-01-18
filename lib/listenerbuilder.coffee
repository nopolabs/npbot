class ListenerBuilder
  constructor: (@botName, @users, @channels, @log) ->

  build: (spec) ->
    if typeof spec == 'function'
      listen = spec
    else
      type = spec.type || 'message'

      users = if spec.user || spec.users
        names = spec.users || []
        names.push spec.user if spec.user
        (user.id for user in @users when names.indexOf(user.name) != -1)
      else
        true

      channels = if spec.channel || spec.channels
        names = spec.channels || []
        names.push spec.channel if spec.channel
        (channel.id for channel in @channels when names.indexOf(channel.name) != -1)
      else
        true

      regex = spec.regex || /.*/

      accept = spec.accept || (msg, matches) =>
        @log.info 'ACCEPT', msg, matches

      @log.debug type, users, channels, regex?.toString()

      isNpBot = (msg) =>
        msg.username and msg.username is @botName

      acceptType = (msg) =>
        msg.type is type

      acceptUser = (msg) =>
        users is true or users.indexOf(msg.user) != -1

      acceptChannel = (msg) =>
        channels is true or channels.indexOf(msg.channel) != -1

      acceptRegex = (msg) =>
        regex.exec msg.text if msg.text

      listen = (msg) =>
        if isNpBot(msg)
          @debug 'isNpBot', 'REJECTED', msg
        else if not acceptType(msg)
          @log.debug 'acceptType', 'REJECTED', type, msg
        else if not acceptUser(msg)
          @log.debug 'acceptUser', 'REJECTED', users, msg
        else if not acceptChannel(msg)
          @log.debug 'acceptChannel', 'REJECTED', channels, msg
        else
          matches = acceptRegex(msg)
          if not matches
            @log.debug 'acceptRegex', 'REJECTED', regex, msg
          else
            accept msg, matches

    (msg) =>
      try
        @log.debug 'LISTEN', msg
        listen(msg)
      catch err
        @log.warn err

module.exports = ListenerBuilder