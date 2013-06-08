express = require 'express'
app = express();
# app.set 'views', __dirname + '/views'
# app.set 'view engine', 'jade'
app.use express.methodOverride()
app.use express.static(__dirname+'/public')

app.get '/traffic/between/:from/and/:to', (req,res)->
	console.log req

app.listen 8080
