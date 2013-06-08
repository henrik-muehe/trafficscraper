define 'controllers/traffic_graph', ['jquery','morris','CanJS','controllers/toggle_group','moment'], ($,Morris,can,ToggleGroup,moment)->
    can.Control
        defaults:
            initialHeight: '300px'
    ,
        # initialize component
        init: ->
            # Set component values
            @from=@to=""
            @time=1
            @view='averages'
            @url=this.options.url
            @graphId=$(this.element).attr('id')+"_graph"
            this.options['id']=@graphId

            # Render view
            this.element.html can.view('controllers/traffic_graph.ejs',this.options)

            # Add subcontrols
            @timeToggleGroup=new ToggleGroup $(this.element).children('.time'),
                items: [ { label: 'Day', value: '1' }, { label: 'Week', value: '7' }, { label: 'Month', value: '28' } ]
                selectedValue: @time
                change: (value) =>
                    @time=value
                    @load()

            @viewToggleGroup=new ToggleGroup $(this.element).children('.view'),
                items: [ { label: 'Values', value: 'values' }, { label: 'Averages', value: 'averages'} ]
                selectedValue: @view
                change: (value) =>
                    @view=value
                    @load()

            this.load()

        avg: (data,n) ->
            n=10 if !n
            newdata=[]
            datawindow=[]
            for entry in data
                datawindow.shift() if datawindow.length == n
                datawindow.push entry
                newentry={timestamp: entry.timestamp}
                for key in @keys
                    count=0
                    sum=0
                    for val in datawindow
                        if val[key]
                            sum+=+val[key]
                            count+=1
                    newentry[key]=sum/count if count>0
                newdata.push newentry
            newdata

        # load data from server
        load: ->
            $.get this.options.url,(content)=>
                dataRaw={}
                for line in content.split("\n")
                    continue if line.length < 5
                    [timestamp,@from,@to,minutes,route]=line.split(';')
                    (dataRaw[timestamp]||={})[route]=minutes
                @data=[]
                keys=[]
                cutoff=new Date().getTime()/1000-(+@time*24*60*60)
                for timestamp,routemap of dataRaw
                    entry={}
                    continue if timestamp<cutoff
                    entry['timestamp']=timestamp*1000
                    for key,mins of routemap
                        entry[key]=mins
                        keys.push key
                    @data.push entry
                @keys=keys.filter (itm,i,a)->i==a.indexOf(itm)
                @data=@avg(@data) if @view=='averages'
                @draw()

        # Callback loading a traffic log and displaying it as a graph
        draw: ->
            $('#'+@graphId).children().remove()
            $(this.element).find("h1").html @from + " to " + @to
            new Morris.Line
                element: @graphId
                data: @data
                xkey: 'timestamp'
                ykeys: @keys
                labels: @keys
                hideHover: true
                ymin: 'auto'
                yLabelFormat: (v) -> Math.round v
                xLabelFormat: (v) =>
                    switch
                        when @time > 7 then moment(v).format("dd Do ha")
                        when @time > 1 then moment(v).format("dd ha")
                        else moment(v).format("ha")

        # Fix graph size on resize
        '{window} resize': (el,ev)->
            clearTimeout @timer
            @timer = setTimeout (=> this.draw()) ,100
