var express = require('express');
var app = express();
var msg = "API endpoint at <p>/law/(law_abbr_name)</p>";
app.get('/', function(req, res){
	  res.send(msg);
});
var port = process.env.PORT || 3000;
app.listen(port);
