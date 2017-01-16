#!/usr/bin/env node

'use strict';

require('coffee-script/register');
var NpBot = require('../lib/npbot');
var config = require('../config');

config.apiToken = process.env.NPBOT_API_KEY || config.apiToken;
config.botName = process.env.NPBOT_NAME || config.botName;
config.logLevel = process.env.NPBOT_LOG_LEVEL || config.logLevel;

var bot = new NpBot(config);

bot.run();
