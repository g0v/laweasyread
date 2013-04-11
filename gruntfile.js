'use strict';

module.exports = function(grunt) {
    grunt.registerTask('livescript', 'compile livescript', function () {
        var done = this.async();

        var shell = require('shelljs');
        var path = require('path');
        var lsc = ['node_modules', '.bin', 'lsc'].join(path.sep);

        // FIXME: Compile changed file only
        shell.exec(lsc + " -cj package.ls");
        shell.exec(lsc + " -c lib");
        shell.exec(lsc + " -c test");

        done();
    });

    grunt.initConfig({
        watch: {
            livescript_src: {
                files: ['package.ls', 'lib/**/*.ls', 'test/**/*.ls'],
                tasks: ['livescript']
            },
        }
    });

    grunt.loadNpmTasks('grunt-contrib-watch');
};
