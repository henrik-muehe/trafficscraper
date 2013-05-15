# Callback loading a traffic log and displaying it as a graph
loadData=(url,graph)->
	$.get url,(content)->
		data={}
		for line in content.split("\n")
			continue if line.length < 5
			[timestamp,from,to,minutes,route]=line.split(';')
			(data[timestamp]||={})[route]=minutes
		data2=[]
		keys=[]
		for timestamp,routemap of data
			entry={}
			entry['timestamp']=timestamp*1000
			for key,mins of routemap
				entry[key]=mins
				keys.push key
			data2.push entry
		uniqueKeys=keys.filter (itm,i,a)->i==a.indexOf(itm)
		$('#'+graph).children().remove()
		new Morris.Line
			element: graph
			data: data2
			xkey: 'timestamp'
			ykeys: uniqueKeys
			labels: uniqueKeys
			hideHover: true
			ymin: 'auto'

# Method that pulls in the two logs and draws them
draw= ->
	loadData('/traffic_outbound.log','traffic_outbound')
	loadData('/traffic_inbound.log','traffic_inbound')

# Debounced resize handler
resizeTimer=null
$(window).resize ->
	clearTimeout resizeTimer
	resizeTimer=setTimeout draw,100

# Initial refresh
draw()

# Refresh every 300 seconds
setTimeout draw,300000
