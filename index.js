"use strict";

module.exports = process.env.LAWEASYREAD_COV
    ? require('./lib-cov/')
    : require('./lib/');
