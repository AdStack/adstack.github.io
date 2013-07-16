###
Modal dialog
###

class Modal

	constructor: ( @params ) ->
		@show()

	show: ->
		if typeof @params == 'object' and @params.content and !@$modal
			@$modal = $( '<div id="modal" />' ).appendTo document.body
			@$modalBody = $( '<div class="modal-body" />' ).appendTo( @$modal )
				.css(
					display: 'inline-block'
					position: 'absolute'
					opacity: 0.01
				).html( @params.content )
				.animate {'opacity': 1}, 200
			@bindEvents()
			if typeof @params.init == 'function'
				@params.init.call this

	close: ->
		if @$modal
			@$modal.remove()
			@$modal = undefined
			@unbindEvents()

	toggle: ->
		if @$modal then @close() else @show()

	bindEvents: ->
		_this = this
		$window = $ window

		$window.on 'keydown.modal', ( e ) ->
			if e.keyCode == 27 then _this.close()

		$window.on( 'resize.modal', ->
			$modalBody = _this.$modalBody;
			dimensions =
				width: parseInt($modalBody.width(), 10) + parseInt($modalBody.css('border-left-width'), 10) * 2
				height: parseInt($modalBody.height(), 10) + parseInt($modalBody.css('border-top-width'), 10) * 2
			left = $window.width() / 2 - dimensions.width / 2
			top = $window.height() / 2 - dimensions.height / 2
			$modalBody.css
				left: left
				top: if top < 0 then 0 else top
		).trigger( 'resize' )

	unbindEvents: ->
		$( window ).off '.modal'

# expose Modal
window.Modal = Modal
