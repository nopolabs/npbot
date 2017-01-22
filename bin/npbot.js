#!/usr/bin/env node

'use strict';

require('coffee-script/register');
var Bunyan = require('bunyan');
var Slack = require('slackbots');
var storage = require('node-persist');
var NpBot = require('../lib/npbot');

var configFile = process.env.NPBOT_CONFIG_FILE || '../config';
var config = require(configFile);
config.apiToken = process.env.NPBOT_API_KEY || config.apiToken;
config.botName = process.env.NPBOT_NAME || config.botName || 'npbot';
config.logLevel = process.env.NPBOT_LOG_LEVEL || config.logLevel || 'info';
config.storageDir = process.env.NPBOT_STORAGE_DIR || config.storageDir || 'data';
if (process.env.NPBOT_SCRIPTS) {
    config.scripts = process.env.NPBOT_SCRIPTS.split(',');
} else {
    config.scripts = ['scripts'];
}

var slack = new Slack({ token: config.apiToken, name: config.botName });
var log = Bunyan.createLogger({name: config.botName, level: config.logLevel});
storage.initSync({dir: config.storageDir, logging: false});

var bot = new NpBot(slack, storage, log, config);

bot.load(config.scripts);

bot.run();
