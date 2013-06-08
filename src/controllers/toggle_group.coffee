define 'controllers/toggle_group', ['jquery','CanJS'], ($,can)->
	can.Control
		defaults:
			items: []
			change: (value)->
	,
		init: ->
			this.element.html can.view('controllers/toggle_group.ejs',this.options)
			if this.options.selectedValue
				$(this.element).find('button[value="'+this.options.selectedValue+'"]').addClass('btn-primary')
				@value=this.options.selectedValue
		'button click': (el,ev)->
			@value=$(el).attr('value')
			$(this.element).find('button').removeClass('btn-primary')
			$(this.element).find('button[value="'+@value+'"]').addClass('btn-primary')
			this.options.change(@value)
