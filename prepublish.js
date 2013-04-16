'use strict';
var path = require('path');
var shell = require('shelljs');

var bin = path.join('node_modules', '.bin');

var lsc = path.join(bin, 'lsc');

shell.exec([lsc, '-cj', 'package.ls'].join(' '));
shell.exec([lsc, '-c', 'lib', 'test', path.join('public', 'js')].join(' '));
