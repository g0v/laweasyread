var shell = require('shelljs');
var path = require('path');

var lsc = ['node_modules', '.bin', 'lsc'].join(path.sep);

var all_test = shell.find('test').filter(
    function (file) { return file.match(/\.ls$/); });

for (var i = 0; i < all_test.length; ++i) {
    console.log("Run " + all_test[i]);
    shell.exec(lsc + " " + all_test[i], function(code){
        if (code !== 0) {
            return code;
        }
    });
}
