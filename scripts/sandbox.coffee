module.exports = (npbot) ->
  { listen, log, send, slack } = npbot

  listen regex: /(fish)/, accept: (msg, matches) =>
    log.debug 'ACCEPTED', msg, matches
    send(type: "typing", channel: msg.channel)
    setTimeout(
      -> slack.postMessage msg.channel, 'Do you like the fish I caught? :fish:',
      5000
    )

