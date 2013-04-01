# =======
# tooltip
# =======

class Tooltip

	constructor: (params) ->
		if typeof params == 'object'
			@$this = $ params.element
			@title = if typeof @$this.attr('data-title') == 'string' then @$this.attr 'data-title' else @$this.attr 'title'
			@$boundingBox = @$this.parents(params.boundingBox).first()
			@arrowSize = params.arrowSize || 17

			@show()

	show: ->
		@$this.attr 'data-title', @title
		@$this.attr 'title', ''

		@$tooltip = $('<div class="tooltip" />').appendTo document.body
		$('<p>' + @title + '</p>').appendTo @$tooltip
		@$arrow = $('<div class="arrow" />').appendTo @$tooltip

		@position()
		@bindEvents()

		@$tooltip.animate
			opacity: 1
		, 150

	position: ->
		xOffset = @$this.offset().left + @$this.width() / 2 - @$tooltip.width() / 2

		if xOffset < @$boundingBox.offset().left
			xOffset = @$boundingBox.offset().left
			@$arrow.css 'left', (@$this.offset().left - @$boundingBox.offset().left + @$this.width() / 2) + 'px'

		if @$this.offset().left + @$tooltip.width() / 2 > @$boundingBox.offset().left + @$boundingBox.width()
			xOffset = @$boundingBox.offset().left + @$boundingBox.width() - @$tooltip.width()
			@$arrow.css
				left: 'auto'
				right: (@$boundingBox.offset().left + @$boundingBox.width() - @$this.offset().left - @$this.width() + @$this.width() / 2) + 'px'

		yOffset = @$this.offset().top - @$tooltip.height() - @arrowSize

		@$tooltip.css
			opacity: 0.01
			left: xOffset
			top: yOffset

	bindEvents: ->
		_this = this
		@$this.on 'mouseout touchend', ->
			_this.destroy()

	destroy: ->
		@$tooltip.remove()
		@$this.attr 'title', @$this.attr 'data-title'
		delete this

# Assign Tooltip to AdStack namespace
window.AdStack = window.AdStack or {}
AdStack.Tooltip = Tooltip