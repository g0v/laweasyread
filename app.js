var express = require('express');

var app = express.createServer(express.logger());

app.get('/', function(request, response) {
	  response.send('Hello World!');
});

app.listen(3000);
