var express = require('express');
var app = express();
var msg = "API endpoint at <p>/laws/(law_abbr_name)</p>";
app.get('/', function(req, res){
	  res.send(msg);
});
app.get('/laws/:query', function  (req, res) {
	res.contentType('application/json');
    return res.json(stub_find_in_laws(req.params.query));
});

function stub_find_in_laws (query) {
	var law_fake = {
		 "law": query,
		 "content": "行為之處罰，以行為時之法律有明文規定者為限。拘束人身自由之保安處分，亦同。",
		 "link": "http://law.moj.gov.tw/LawClass/LawSingle.aspx?Pcode=C0000001&FLNO=1",
	 };
	law_fake_JSON = law_fake;
	return law_fake_JSON;
}


var port = process.env.PORT || 3000;
app.listen(port);
