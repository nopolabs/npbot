module.exports = (bot) ->
  listen = bot.listen
  log = bot.log
  slack = bot.slack

  listen user: 'drevel', channel: 'kip-sandbox', regex: /(fish)/, accept: (msg, matches) =>
    log.debug 'ACCEPTED', msg, matches
    slack.postMessage msg.channel, 'I caught a fish'
