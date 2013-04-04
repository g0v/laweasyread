"use strict";
var optimist = require('optimist');
var server = require('./').server;

var config = optimist.default({
    'mongo_uri': process.env.MONGO_URI || 'mongodb://localhost:27017/laweasyread',
    'port': process.env.PORT || 3000
}).argv;

server.start(config);
