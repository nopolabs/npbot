#!/usr/bin/env node

'use strict';

require('coffee-script/register');
var Bunyan = require('bunyan');
var Slack = require('slackbots');
var NpBot = require('../lib/npbot');
var config = require('../config');

config.apiToken = process.env.NPBOT_API_KEY || config.apiToken;
config.botName = process.env.NPBOT_NAME || config.botName;
config.logLevel = process.env.NPBOT_LOG_LEVEL || config.logLevel;

var slack = new Slack({ token: config.apiToken, name: config.botName });
var log = Bunyan.createLogger({name: config.botName, level: config.logLevel});

var bot = new NpBot(slack, log, config);

bot.load('./scripts');

bot.run();
