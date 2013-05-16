window.TrafficGraph = can.Control
    defaults:
        mode: 'day'
        initialHeight: '300px'
,
    init: ->
        @url=this.options.url
        @graphId=$(this.element).attr('id')+"_graph"
        @mode=this.options.mode
        this.options['id']=@graphId
        this.element.html can.view('views/traffic_graph.ejs',this.options)
        this.load()

    cutoff: ->
        days=1 if @mode=="day"
        days=7 if @mode=="week"
        days=28 if @mode=="month"
        new Date().getTime()/1000-(days*24*60*60)


    load: ->
        $.get this.options.url,(content)=>
            dataRaw={}
            for line in content.split("\n")
                continue if line.length < 5
                [timestamp,from,to,minutes,route]=line.split(';')
                (dataRaw[timestamp]||={})[route]=minutes
            @data=[]
            keys=[]
            cutoff=@cutoff()
            for timestamp,routemap of dataRaw
                entry={}
                continue if timestamp<cutoff
                entry['timestamp']=timestamp*1000
                for key,mins of routemap
                    entry[key]=mins
                    keys.push key
                @data.push entry
            @keys=keys.filter (itm,i,a)->i==a.indexOf(itm)
            @draw()

    # Callback loading a traffic log and displaying it as a graph
    draw: ->
        $('#'+@graphId).children().remove()
        new Morris.Line
            element: @graphId
            data: @data
            xkey: 'timestamp'
            ykeys: @keys
            labels: @keys
            hideHover: true
            ymin: 'auto'

    '{window} resize': (el,ev)->
        clearTimeout @timer
        @timer = setTimeout (=> this.draw()) ,100

    # Recolor active button
    'button click': (el,ev)->
        @mode=$(el).attr('mode')
        $(this.element).find('button').removeClass('btn-primary')
        $(this.element).find('button[mode="'+@mode+'"]').addClass('btn-primary')
        @load()

