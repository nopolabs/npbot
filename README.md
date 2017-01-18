# npbot

The NpBot is a Slack bot that uses Slack's RTM API.
NpBot provides an alternative using hubot with the hubot-slack adapter.

## Installation

Be sure to have npm and node (`>= 0.10` version, or io.js `>= 1.0`) installed.

Clone this repo and:

```bash
$ npm install
```

On OSX:

Per https://github.com/websockets/bufferutil/issues/17 you may need:

```bash
cd /usr/local/lib
sudo ln -s ../../lib/libSystem.B.dylib libgcc_s.10.5.dylib
sudo ln -s ../../lib/libSystem.B.dylib libgcc_s.10.4.dylib
```

## Configuration

To use NpBot you must have an [API token](#getting-the-api-token-for-your-slack-channel) to authenticate the bot on your slack channel.

```bash
cp config.coffee.sample config.cofee
```

Edit config.coffee to set apiToken, botName and logLevel

The following environment variables can be used to override the settings in config.coffee:

`OSBOT_API_KEY`, `OSBOT_NAME`, `OSBOT_LOG_LEVEL`

## Running the NpBot

node ./bin/npbot.js

Or with formatted logging:

node ./bin/npbot.js | ./node_modules/.bin/bunyan

## Getting the API token for your Slack channel

To allow the NpBot to connect your Slack channel you must provide him an API key. To retrieve it you need to add a new Bot in your Slack organization by visiting the following url: https://*yourorganization*.slack.com/services/new/bot, where *yourorganization* must be substituted with the name of your organization (e.g. https://*loige*.slack.com/services/new/bot). Ensure you are logged to your Slack organization in your browser and you have the admin rights to add a new bot.

You will find your API key under the field API Token, copy it in a safe place and get ready to use it.



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
