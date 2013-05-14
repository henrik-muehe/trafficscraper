cheerio = require('cheerio')
request = require('request')

scrapeTraffic=(err,resp,html) ->
  if err
  	return console.error(err)

  ts=Math.round(new Date().getTime() / 1000)
  timePattern = new RegExp(/(\d+)/)
  routePattern = new RegExp(/Minuten[\s\t]+(.*?)$/)
  $ = cheerio.load(html)
  $('.dir-altroute-inner').each (index,value)->
  	time=($(value)).children('.altroute-aux').text().match(timePattern)[0]
  	route=($(value)).children('div').text().match(routePattern)[1].match(routePattern)[1]
  	console.log ts + ";" + time + ";" + route


request "http://maps.google.de/maps?saddr=Boltzmannstra%C3%9Fe,+Garching&daddr=Theresienwiese,+M%C3%BCnchen&hl=de&ie=UTF8", scrapeTraffic

