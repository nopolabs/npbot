# NpBot

The NpBot is a Slack bot that uses Slack's RTM API.
NpBot provides an alternative using hubot with the hubot-slack adapter.

## Installation

Be sure to have npm and node (`>= 0.10` version, or io.js `>= 1.0`) installed.

Clone this repo and:

```bash
$ npm install
```

On OSX, per https://github.com/websockets/bufferutil/issues/17 you may need:

```bash
cd /usr/local/lib
sudo ln -s ../../lib/libSystem.B.dylib libgcc_s.10.5.dylib
sudo ln -s ../../lib/libSystem.B.dylib libgcc_s.10.4.dylib
```

## Configuration

To use NpBot you must have an [API token](#getting-the-api-token-for-your-slack-channel) to authenticate the bot on your slack channel.

```bash
cp config.coffee.sample config.coffee
```

Edit config.coffee to set apiToken, botName and logLevel

The following environment variables can be used to override the settings in config.coffee:

 - `NPBOT_API_KEY` Slack API key (see below)
 - `NPBOT_NAME` A name for your bot.
 - `NPBOT_LOG_LEVEL` `info` by default, set to `debug` for more verbose logging.
 - `NPBOT_SCRIPTS` A comma separated list of files and/or directories with NpBot scripts to load.
 
## NpBot scripts

Here's an example (sandbox.coffee):
```
module.exports = (npbot) ->
  { listen, log, send, slack } = npbot

  listen regex: /(fish)/, accept: (msg, matches) =>
    log.debug 'ACCEPTED', msg, matches
    send(type: "typing", channel: msg.channel)
    setTimeout(
      -> slack.postMessage msg.channel, 'Do you like the fish I caught? :fish:',
      5000
    )
```

## NpBot listeners
A `spec` can either be a function which will receive as messages of type `message`
or it can be an object with some or all of these properties:

- `type` message type to match
- `user` user name to match
- `users` a list of user names to match
- `channel` channel name to match
- `channels` a list of channel names to match
- `regex` a regex to match message text, producing athe matches argument for `accept`
- `accept` a function to call if the specified properties are matched.

NpBot uses `ListenerBuilder.build(spec)` to convert specs into listener functions
that will call `accept(msg, matches)`

## Running the NpBot

node ./bin/npbot.js

Or with formatted logging:

node ./bin/npbot.js | ./node_modules/.bin/bunyan

## Getting the API token for your Slack channel

To allow the NpBot to connect your Slack channel you must provide him an API key. 
To retrieve it you need to add a new Bot in your Slack organization by visiting the following url: 
https://*yourorganization*.slack.com/services/new/bot, where *yourorganization* must be substituted 
with the name of your organization (e.g. https://*opensky*.slack.com/services/new/bot). 
Ensure you are logged to your Slack organization in your browser and you have the admin rights to add a new bot.

You will find your API key under the field API Token, copy it in a safe place and get ready to use it.

When you add a bot you also specify the slack username it will use, e.g. npbot.
You will need to invite your bot into the channels you would like it to listen to.
You can do this by mentioning the bot's name in the channel (e.g. @npbot) and clicking
on Slack's offer to invite the bot to join.

## Launching the bot from source

If you downloaded the source code of the bot you can run it using NPM with:

```bash
$ npm start
```

## Bugs and improvements


## The Making of

NpBot uses the slackbots API and was built based on experience with hubot and NorrisBot.

- https://github.com/mishk0/slack-bot-api
- https://github.com/github/hubot
- https://github.com/lmammino/norrisbot

## License

Licensed under [MIT License](LICENSE). © Dan Revel.
