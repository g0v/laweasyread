'use strict';

var optimist = require('optimist');
var path = require('path');
var shell = require('shelljs');

var bin = path.join('node_modules', '.bin');

var karma = path.join(bin, 'karma');
var lsc = path.join(bin, 'lsc');
var mocha = path.join(bin, 'mocha');
var jscoverage = path.join(bin, 'jscoverage');

var compile = function (src) {
    for (var i = 0; i < src.length; ++i) {
        shell.exec(lsc + " -c " + src[i]);
    }
};

var create_cov_dst_path = function (src) {
    var ret = src.split(path.sep);
    ret[0] += '-cov';
    return ret.join(path.sep);
};

var generate_coverage = function (src) {
    var all_js = shell.find(src).filter(function (file) {
        return /\.js$/.test(file); });
    for (var i = 0; i < all_js.length; ++i) {
        shell.exec([
            jscoverage, all_js[i], create_cov_dst_path(all_js[i])
        ].join(' '));
    }
};

var find_all_test_scripts = function () {
    return shell.find('test').filter(function (file) {
        return /_mocha\.js$/.test(file); } );
};

(function () {
    var argv, cmd, ret;

    argv = optimist
        .boolean(['coverage'])
        .default({
            'reporter': 'dot'
        })
        .argv;

    compile(['lib', 'test']);

    if (argv.coverage) {
        generate_coverage(['lib']);

        if (!/cov/.test(argv.reporter)) {
            argv.reporter = 'html-cov';
        }

        process.env.LAWEASYREAD_COV = true;
    }

    cmd = [mocha,
        '--no-colors',
        '--growl',
        '--reporter', argv.reporter];
    cmd = cmd.concat(find_all_test_scripts());

    ret = shell.exec(cmd.join(' '));
    if (ret.code !== 0) shell.exit(ret.code);

    cmd = [karma, 'start',
        '--single-run',
        '--browsers', 'PhantomJS'];

    ret = shell.exec(cmd.join(' '));
    if (ret.code !== 0) shell.exit(ret.code);
})();
