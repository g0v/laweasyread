'use strict';

var fs = require('fs');
var path = require('path');
var shell = require('shelljs');

var bin = path.join('node_modules', '.bin');

var karma = path.join(bin, 'karma');
var lsc = path.join(bin, 'lsc');
var mocha = path.join(bin, 'mocha');
var jscoverage = path.join(bin, 'jscoverage');

var compile = function (src) {
    for (var i = 0; i < src.length; ++i) {
        shell.exec([lsc, '-c', src[i]].join(' '));
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
    var cmd;
    var scripts;
    var ret;

    compile(['lib', 'test']);
    generate_coverage(['lib']);

    scripts = find_all_test_scripts();

    // server side unit test
    cmd = [mocha,
        '--no-colors',
        '--growl'];
    cmd = cmd.concat(scripts);
    ret = shell.exec(cmd.join(' '));
    if (ret.code !== 0) shell.exit(ret.code);

    // server side coverage
    process.env.LAWEASYREAD_COV = true;
    cmd = [mocha,
        '--reporter', 'html-cov']
    cmd = cmd.concat(scripts);
    ret = shell.exec(cmd.join(' '), { silent: true });
    if (ret.code !== 0) shell.exit(ret.code);
    fs.writeFileSync(path.join('coverage', 'report.html'), ret.output);

    // client side unit test & coverage
    cmd = [karma, 'start',
        '--single-run',
        '--browsers', 'PhantomJS'];
    ret = shell.exec(cmd.join(' '));
    if (ret.code !== 0) shell.exit(ret.code);
})();
