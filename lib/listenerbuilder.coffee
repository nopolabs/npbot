class ListenerBuilder
  constructor: (@botName, @users, @channels, @log) ->

    @userMap = {}
    for user in @users
      @userMap[user.name] = user.id

    @channelMap = {}
    for channel in @channels
      @channelMap[channel.name] = channel.id

  userId: (name) ->
    @userMap[name]

  channelId: (name) ->
    @channelMap[name]

  userIds: (names) ->
    (@userId(name) for name in names)

  channelIds: (names) ->
    (@channelId(name) for name in names)

  findMentioned: (mentions, text) ->
    mentioned = []
    for name, regex of mentions
      mentioned.push name if regex.test(text)
    mentioned if mentioned.length > 0

  build: (spec) ->
    if typeof spec == 'function'
      listen = spec
    else
      type = spec.type || 'message'

      users = if spec.user || spec.users
        names = spec.users || []
        names.push spec.user if spec.user
        @userIds names
      else
        true

      channels = if spec.channel || spec.channels
        names = spec.channels || []
        names.push spec.channel if spec.channel
        @channelIds names
      else
        true

      mentions = if spec.mentions
        spec.mentions = [spec.mentions] if not Array.isArray(spec.mentions)
        regexes = {}
        for mention in spec.mentions
          mention = mention.replace(/^@/, '')
          regexes[mention] = new RegExp("<@#{@userId(mention)}>")
        regexes
      else
        true

      regex = spec.regex || /.*/

      accept = spec.accept || (msg, matches) =>
        @log.info 'ACCEPT', msg, matches

      @log.debug type, users, channels, mentions, regex?.toString()

      isNpBot = (msg) =>
        msg.username and msg.username is @botName

      acceptType = (msg) =>
        msg.type is type

      acceptUser = (msg) =>
        users is true or users.indexOf(msg.user) != -1

      acceptChannel = (msg) =>
        channels is true or channels.indexOf(msg.channel) != -1

      acceptMentions = (msg) =>
        mentions is true or (msg.text and @findMentioned(mentions, msg.text))

      acceptRegex = (msg) =>
        regex.exec msg.text if msg.text

      listen = (msg) =>
        if isNpBot(msg)
          @log.debug 'isNpBot', 'REJECTED', msg
        else if not acceptType(msg)
          @log.debug 'acceptType', 'REJECTED', type, msg
        else if not acceptUser(msg)
          @log.debug 'acceptUser', 'REJECTED', users, msg
        else if not acceptChannel(msg)
          @log.debug 'acceptChannel', 'REJECTED', channels, msg
        else
          mentioned = acceptMentions(msg)
          if not mentioned
            @log.debug 'acceptMentions', 'REJECTED', mentions, msg
          else
            matches = acceptRegex(msg)
            if not matches
              @log.info 'acceptRegex', 'REJECTED', regex, msg
            else
              accept msg, { matches: matches, mentioned: mentioned }

    (msg) =>
      try
        @log.debug 'LISTEN', msg
        listen(msg)
      catch err
        @log.warn err

module.exports = ListenerBuilder