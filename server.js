// Generated by CoffeeScript 1.6.3
(function() {
  var app, express;

  express = require('express');

  app = express();

  app.use(express.methodOverride());

  app.use(express["static"](__dirname + '/public'));

  app.get('/traffic/between/:from/and/:to', function(req, res) {
    return console.log(req);
  });

  app.listen(8080);

}).call(this);
