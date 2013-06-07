express = require 'express'
app = express();

app.use express.methodOverride()

allowCrossDomain = (req, res, next)->
    res.header 'Access-Control-Allow-Origin', '*'
    res.header 'Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE'
    res.header 'Access-Control-Allow-Headers', 'Content-Type, Authorization'

    if 'OPTIONS' == req.method
      res.send 200
    else
      next()
app.use allowCrossDomain

app.use express.static(__dirname+'/')

app.get '/traffic/between/:from/and/:to', (req,res,next)->
	console.log req

app.listen 8080
