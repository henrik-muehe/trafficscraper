cheerio = require('cheerio')
request = require('request')

if process.argv.length != 4
  console.error "traffic.js <from> <to>"
  process.exit 1

from=process.argv[2]
to=process.argv[3]

scrapeTraffic=(err,resp,html) ->
  if err
  	return console.error(err)

  ts=Math.round(new Date().getTime() / 1000)

  timeHourMinPattern = new RegExp(/traffic:[\s\t]+(\d+)[\s\t]+\w+[\s\t]+(\d+)[\s\t]+\w+/)
  timeMinPattern = new RegExp(/traffic:[\s\t]+(\d+)[\s\t]+\w+/)
  routePattern = new RegExp(/Minuten[\s\t]+(.*?)$/)
  $ = cheerio.load(html)
  $('.dir-altroute-inner').each (index,value)->
    [hours,mins]=[0,0]
    trafficString=($(value)).children('div').slice(1,2).children('span').text()
    match=trafficString.match(timeHourMinPattern)
    if match
      [trash,hours,mins]=match
    else
      match=trafficString.match(timeMinPattern)
      [trash,mins]=match

    route=($(value)).children('div').slice(2,3).text()
    time=+mins+(+hours*60)
    console.log ts + ";" + from + ";" + to + ";" + time + ";" + route


request "http://maps.google.com/maps?saddr="+encodeURIComponent(from)+"&daddr="+encodeURIComponent(to)+"&ie=UTF8", scrapeTraffic
