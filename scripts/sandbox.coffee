module.exports = (bot) ->
  bot.listen user: 'drevel', channel: 'kip-sandbox', regex: /(fish)/, accept: (msg, matches) =>
    bot.log.info 'CAUGHT', msg.text, matches
