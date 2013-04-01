var shell = require('shelljs');
var path = require('path');

var lsc = ['node_modules', '.bin', 'lsc'].join(path.sep);

shell.exec(lsc + " -cj package.ls");
shell.exec(lsc + " -c server");
