'use strict';

module.exports = function(grunt) {
    var growl = require('growl');
    var path = require('path');
    var shell = require('shelljs');

    var bin = ['node_modules', '.bin'].join(path.sep);

    var lsc = [bin, 'lsc'].join(path.sep);
    var npm = 'npm';

    grunt.registerTask('livescript_src', 'update LiveScript source', function () {
        var done = this.async();
        // FIXME: Compile changed file only
        shell.exec(lsc + ' -c lib');
        shell.exec(lsc + ' -c test');
        grunt.task.run('test');
        done();
    });

    grunt.registerTask('package_ls', 'update package.ls', function () {
        var done = this.async();
        shell.exec(lsc + ' -cj package.ls');
        shell.exec(npm + ' install');
        growl('Update package.ls', { title: 'Completed' });
        done();
    });

    grunt.registerTask('test', 'run test', function () {
        var done = this.async();
        shell.exec(npm + ' test');
        done();
    });

    grunt.initConfig({
        watch: {
            livescript_src: {
                files: ['lib/**/*.ls', 'test/**/*.ls'],
                tasks: ['livescript_src']
            },
            package_ls: {
                files: ['package.ls'],
                tasks: ['package_ls']
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['watch']);
};
