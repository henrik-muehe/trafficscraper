express = require 'express'
app = express();

app.use express.static(__dirname+'/')

app.get '/traffic/between/:from/and/:to', (req,res,next)->
	console.log req

app.listen 8080
