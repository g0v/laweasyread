"use strict";
var shell = require('shelljs');
var path = require('path');

var lsc = ['node_modules', '.bin', 'lsc'].join(path.sep);
var jade = ['node_modules', '.bin', 'jade'].join(path.sep);

shell.exec(lsc + " -cj package.ls");
shell.exec(lsc + " -c server");
shell.exec(lsc + " -c lib");

shell.exec(lsc + " -c public");
