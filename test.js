var shell = require('shelljs');
var path = require('path');

var bin = ['node_modules', '.bin'].join(path.sep);
var test_path = 'test';

var mocha = [bin, 'mocha'].join(path.sep);
var lsc = [bin, 'lsc'].join(path.sep);

shell.exec(lsc + " -c " + test_path);
shell.exec(mocha + " " + test_path);
