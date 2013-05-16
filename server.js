var express = require('express');
var app = express();

app.use(express.static(__dirname+'/'));

app.get('/traffic/between/:from/and/:to', function(req,res,next) {
	console.log(req);
});

app.listen(8080)
